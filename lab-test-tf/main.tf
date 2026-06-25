# Minimal repro for case 5403063369 — no cloud providers required.
# Keeps the exact failure pattern: split("-", var.cloud)[1] when cloud is unset.

locals {
  cloud_file = "${split("-", var.clouds)[1]}.yaml"
  cloud_data = yamldecode(file("${path.module}/${local.cloud_file}"))
}

output "debug_cloud_file" {
  value = local.cloud_file
}

output "debug_cloud_data" {
  value = local.cloud_data
}

output "debug_group" {
  value = var.groups
}
