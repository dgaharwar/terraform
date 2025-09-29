provider "nutanix" {
  username = var.nutanix_username
  password = var.nutanix_password
  endpoint = var.nutanix_endpoint
  insecure = true
  port     = 9440
}

# Data sources
data "nutanix_cluster" "cluster" {
  name = "labs-nutanix-aws-2"
}

data "nutanix_subnet" "subnet" {
  subnet_name = "PC-Net"
}

data "nutanix_image" "image" {
  image_name = var.nutanix_imagename
}

# Debug output (optional, can be removed later)
output "debug_vm_categories" {
  value = var.vm_categories
}

# Virtual Machine resource
resource "nutanix_virtual_machine" "vm" {
  name                 = lower(var.vm_name)
  description          = "VM created via Terraform"
  provider             = nutanix
  cluster_uuid         = data.nutanix_cluster.cluster.id
  num_vcpus_per_socket = 2
  num_sockets          = 1
  memory_size_mib      = 4096

  # Categories mapped directly from Morpheus option list
  categories = {
    for cat in var.vm_categories : cat.name => cat.value
  }

  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.id
  }

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
