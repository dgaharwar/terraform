output "vm_ip_address" {
  value = nutanix_virtual_machine.ubuntu_vm.nic_list_status[0].ip_endpoint_list[0].ip
}
