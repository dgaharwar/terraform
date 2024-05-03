# resource "vsphere_virtual_machine" "rke2_master" {
#   depends_on       = [local_file.userdataController]
#   count            = var.masterCount
#   name             = "${var.rke2ClusterName}-${var.hostnameMaster}-${count.index}"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.datastore.id
#   folder           = var.folder
#   num_cpus         = 8
#   memory           = 8096
#   guest_id         = data.vsphere_virtual_machine.template.guest_id
#   scsi_type        = data.vsphere_virtual_machine.template.scsi_type
#   # firmware         = "efi"

#   cdrom {
#     client_device = true
#   }

#   network_interface {
#     network_id   = data.vsphere_network.network.id
#     adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
#   }
#   wait_for_guest_net_timeout = 0

#   cdrom {
#     client_device = true
#   }

#   disk {
#     label       = "disk0"
#     size        = 100
#     unit_number = 0
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template.id
#   }

#   custom_attributes = tomap({ "${data.vsphere_custom_attribute.attributeCIStatus.id}" = "no import", "${data.vsphere_custom_attribute.attributeOwner.id}" = "contai-ner@hzd.hessen.de", "${data.vsphere_custom_attribute.attributeErsteller.id}" = "Terraform CaaS" })

#   extra_config = {
#     "guestinfo.metadata" = data.template_file.metadata[count.index].rendered
#     "guestinfo.userdata" = data.template_file.userdataController.rendered
#   }
# }
