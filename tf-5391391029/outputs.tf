output "vm_id" {
  value = nutanix_virtual_machine.test_vm.id
}

output "vm_name" {
  value = nutanix_virtual_machine.test_vm.name
}

output "categories" {
  value = var.vm_categories
}
