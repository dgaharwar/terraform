output "vm_ip_address" {
  value = var.assign_public_ip == true ? google_compute_instance.vm.network_interface.0.access_config.0.nat_ip : google_compute_instance.vm.network_interface.0.network_ip
}