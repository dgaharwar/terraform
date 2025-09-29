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

locals {
  # Remove brackets from the string
  raw_categories = replace(replace(var.vm_categories, "[", ""), "]", "")

  # Trim spaces from start/end of the string and split into list
  categories_list = length(trim(local.raw_categories, " ")) > 0 ? split(",", local.raw_categories) : []
}

# Debug output
output "debug_categories_list" {
  value = local.categories_list
}

# VM Resource
resource "nutanix_virtual_machine" "vm" {
  name                 = lower(var.vm_name)
  description          = "VM created via Terraform"
  provider             = nutanix
  cluster_uuid         = data.nutanix_cluster.cluster.id
  num_vcpus_per_socket = 2
  num_sockets          = 1
  memory_size_mib      = 4096

dynamic "categories" {
  for_each = local.categories_list
  content {
    name  = split(":", trim(categories.value))[0]
    value = split(":", trim(categories.value))[1]
  }
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


