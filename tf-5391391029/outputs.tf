output "ipv4Ip" {
  value = infoblox_ip_allocation.allocation.allocated_ipv4_addr
}

output "cloudIs" {
  value = split("-", var.cloud)[1]
}

output "clusterIs" {
  value = local.selected_cluster.name
}

