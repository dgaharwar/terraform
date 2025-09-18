# ------------------------------
# Create Category Keys
# ------------------------------
resource "nutanix_category_key" "keys" {
  for_each    = local.category_keys
  name        = each.value
  description = "Auto-created key from Terraform"
}

# ------------------------------
# Create Category Values
# ------------------------------
resource "nutanix_category_value" "values" {
  for_each = { for c in local.category_values : "${c.name}" => c }

  name            = each.value.value
  category_key_id  = nutanix_category_key.keys[split(":", each.value.name)[0]].id
}

# ------------------------------
# Create VM and attach categories
# ------------------------------
resource "nutanix_virtual_machine" "vm" {
  name                 = var.vm_name
  cluster_uuid         = var.cluster_uuid
  memory_size_mib      = 4096
  num_sockets          = 1
  num_vcpus_per_socket = 2

  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = var.image_uuid
    }

    device_properties {
      device_type = "DISK"
    }
  }

  nic_list {
    subnet_uuid = var.subnet_uuid
  }

  # Attach categories dynamically
  dynamic "categories" {
    for_each = var.categories_dataset
    content {
      name  = split(":", categories.value.name)[0]
      value = categories.value.value
    }
  }

  depends_on = [nutanix_category_value.values]
}