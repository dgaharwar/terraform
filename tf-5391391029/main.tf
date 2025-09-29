locals {
  cloud_file = "${split("-", var.cloud)[1]}.yaml"
  cloud_data = yamldecode(file(local.cloud_file))
}


provider "infoblox" {
  server = var.infoblox_endpoint
  username = var.infoblox_username
  password = var.infoblox_password
}


provider "nutanix" {
  username     = var.nutanix_username
  password     = var.nutanix_password
  endpoint     = local.cloud_data.nutanix_endpoint
  insecure     = local.cloud_data.nutanix_insecure
  wait_timeout = local.cloud_data.nutanix_wait_timeout
  port         = local.cloud_data.nutanix_port
}


provider "http" {}

data "infoblox_ipv4_network" "net1" {
  filters = {
    network = null
    "*VLANName" = var.vlan
  }
}


data "infoblox_dns_view" "net1" {
  filters = {                     
  }
}


locals {
  cidr = data.infoblox_ipv4_network.net1.results[0].cidr
}

locals {
  gateway_ip = cidrhost(local.cidr, 1)  
}


locals {
  subnet_mask = cidrnetmask(local.cidr)
}


locals {
  parts = split("/", local.cidr)  

  prefix_length = local.parts[1]   
}

resource "infoblox_ip_allocation" "allocation" {
  dns_view = data.infoblox_dns_view.net1.results[0].name
  network_view = data.infoblox_ipv4_network.net1.results[0].network_view
  fqdn = "${var.hostname}.${var.dns_domain}"
  ipv4_cidr = data.infoblox_ipv4_network.net1.results[0].cidr
  provisioner "local-exec" {
    command = <<-EOT
    echo "API is sneller dan DNS, sleep 2" ; \
    sleep 2 ; \
    dig +short ${var.hostname}.${var.dns_domain} ; \
    dig +short -x ${infoblox_ip_allocation.allocation.allocated_ipv4_addr}
    EOT
  }
  depends_on = [data.infoblox_ipv4_network.net1]
}

data "nutanix_clusters" "clusters" {
}

locals {
  selected_cluster = [
    for cluster in data.nutanix_clusters.clusters.entities :
    cluster if cluster.name == var.cluster
  ][0] 
}

data "nutanix_subnets" "subnets" {
 metadata {
   filter = "cluster_name==${var.cluster}"
 }
}


locals {
  selected_subnet = [
    for subnet in data.nutanix_subnets.subnets.entities :
     subnet if subnet.name == var.vlan
    ]
}

data "nutanix_subnet" "subnet" {
  subnet_id = local.selected_subnet[0].metadata.uuid
}


data "nutanix_image" "image" {
  image_name = var.nutanix_imagename
}

data "http" "list_containers" {
  url = "https://${local.selected_cluster.external_ip}:9440/api/nutanix/v2.0/storage_containers"
  method = "GET"
  insecure = true

    request_headers = {
    Authorization = "Basic ${base64encode("${var.nutanix_username}:${var.nutanix_password}")}"
    Accept = "application/json"
    Content-type  = "application/json"
  }
} 

locals {
  containers = jsondecode(data.http.list_containers.response_body)
 }

locals {
  selected_storage_container = [
   for container in local.containers.entities : container
    if container.name == var.storagecontainer
   ]
}

data "template_file" "cloud_init"{
  template  = file ( "${path.module}/${var.cloud_init}"  )
  vars = {
    ipv4_address      = infoblox_ip_allocation.allocation.allocated_ipv4_addr
    ipv4_gateway      = local.gateway_ip
    ipv4_nameservers  = var.ipv4_nameservers
    ipv4_maskbits     = local.parts[1]
    hostname          = lower(var.hostname)
    dnsdomain         = var.dns_domain
  }
  depends_on = [ infoblox_ip_allocation.allocation ]
}

data "template_file" "unattend" {
  template  = file ( "${path.module}/${var.unattend}" )
  vars = {
    ipv4_address        = infoblox_ip_allocation.allocation.allocated_ipv4_addr
    ipv4_gateway        = local.gateway_ip
    ipv4_mask           = local.subnet_mask
    ipv4_nameservers    = var.ipv4_nameservers
    hostname            = upper(var.hostname)
    dnsdomain           = var.dns_domain
    ntpserver           = var.ntp_server
    admin_username      = var.windows_admin_username
    admin_password      = var.windows_admin_password
    admin_passwordunenc = var.windows_admin_unenc
  }
  depends_on = [ infoblox_ip_allocation.allocation ]
}

locals {
  guest_customization_sysprep = var.os_type == "windows" ? {
    install_type = "PREPARED"
    unattend_xml = base64encode(data.template_file.unattend.rendered)
  } : {}
  guest_customization_cloud_init_user_data = var.os_type == "redhat" ? data.template_file.cloud_init.rendered : ""
  guest_customization_cloud_init_rendered = base64encode(local.guest_customization_cloud_init_user_data)
}

locals {
  disk_configs = [
    for i, disk_size in compact(split(",",var.extradisksizes)) : {
      disk_size_bytes = tonumber(disk_size) * 1024 * 1024 * 1024
      storage_config = {
        storage_container_reference = {
          kind = "storage_container"
          uuid = local.selected_storage_container[0].storage_container_uuid
        }
      }
      device_properties = {
        device_type   = "DISK"
        disk_address = {
          adapter_type = "SCSI"
          device_index = i + 1
        }
      }
    }
  ]
}

locals {
  temp = var.vm_categories == "null" ? "" : var.vm_categories
  
  trimmed = trim(local.temp, "[]")

  cleaned = replace(local.trimmed, " ", "")

  categories_list = local.cleaned != "" ? split(",", local.cleaned) : []
}


output "debug_categories_list" {
  value = local.categories_list
}


resource "nutanix_virtual_machine" "vm" {
  name                 = lower(var.vm_name)
  description          = var.vm_description
  provider             = nutanix
  cluster_uuid         = local.selected_cluster.metadata.uuid
  num_vcpus_per_socket = var.num_vcpus_per_socket
  num_sockets          = var.num_sockets
  memory_size_mib      = var.memory_size_mib
  machine_type         = var.nutanix_machine_type
  boot_type            = var.boot_type

   dynamic "categories" {
    # If categories_list has 0 items skip entire dynamic
    for_each = length(local.categories_list) > 0 ? local.categories_list : []
    
    # for debugging to skip dynamic always
    #for_each = length(local.categories_list) > 0 ? [] : []

      content {
        name = split(":", categories.value)[0]
        value = split(":", categories.value)[1]
      }
  }

  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.id
  }

  
  guest_customization_sysprep = ( var.os_type == "windows" ? local.guest_customization_sysprep : null )
  guest_customization_cloud_init_user_data = ( var.os_type == "redhat" ?  local.guest_customization_cloud_init_rendered : null )


  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.image.id
    }
    storage_config {
      storage_container_reference {
        kind = "storage_container"
        uuid = local.selected_storage_container[0].storage_container_uuid
      }
    }
  }
 
  lifecycle {
    ignore_changes = [ disk_list[0].data_source_reference.uuid ]
  }

  dynamic "disk_list" {
    for_each = local.disk_configs
    content {
      disk_size_bytes = disk_list.value.disk_size_bytes
      
      storage_config {
        storage_container_reference {
          kind = disk_list.value.storage_config.storage_container_reference.kind
          uuid = local.selected_storage_container[0].storage_container_uuid
        }
      }
      
      device_properties {
        device_type = disk_list.value.device_properties.device_type
        disk_address = {
          adapter_type = disk_list.value.device_properties.disk_address.adapter_type
          device_index = disk_list.value.device_properties.disk_address.device_index
        }
      }
    }
  }
}
