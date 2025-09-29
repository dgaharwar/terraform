provider "nutanix" {
  username     = var.nutanix_username
  password     = var.nutanix_password
  endpoint     = var.nutanix_endpoint
  insecure     = true
  port         = 9440
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

data "template_file" "cloud_init"{
  template  = file ( "${path.module}/${var.cloud_init}"  )
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
  provider             = nutanix
  cluster_uuid         = local.selected_cluster.metadata.uuid
  num_vcpus_per_socket = 2
  num_sockets          = 1
  memory_size_mib      = 4

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

   guest_customization_cloud_init_user_data = ( var.os_type == "redhat" ?  local.guest_customization_cloud_init_rendered : null )

  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.image.id
    }
  }
 
  lifecycle {
    ignore_changes = [ disk_list[0].data_source_reference.uuid ]
  }
}
