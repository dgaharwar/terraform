# data "vault_kv_secret_v2" "rancher_api_user_admin" {
#   mount = "secret"
#   name  = "caas/rancher/api"
# }

# data "vault_kv_secret_v2" "vsphere_ref_rancher_serviceaccount" {
#   mount = "secret"
#   name  = "caas/vsphere/ref"
# }

# data "vsphere_datacenter" "datacenter" {
#   name = var.datacenterName
# }

# data "vsphere_compute_cluster" "cluster" {
#   name          = var.vSphereClusterName
#   datacenter_id = data.vsphere_datacenter.datacenter.id
# }

# data "vsphere_datastore" "datastore" {
#   name          = var.datastoreName
#   datacenter_id = data.vsphere_datacenter.datacenter.id
# }

# /*
# data vsphere_datastore_cluster "this" {
#   name          = var.datastore_name
#   datacenter_id = data.vsphere_datacenter.this.id
# }
# */

# data "vsphere_network" "network" {
#   name          = var.vmNetworkName
#   datacenter_id = data.vsphere_datacenter.datacenter.id
# }

# data "vsphere_virtual_machine" "template" {
#   name          = var.templateName
#   datacenter_id = data.vsphere_datacenter.datacenter.id
# }

# data "vsphere_custom_attribute" "attributeCIStatus" {
#   name = "CI-Status"
# }

# data "vsphere_custom_attribute" "attributeOwner" {
#   name = "Postfach-Ansprechpartner"
# }


# data "vsphere_custom_attribute" "attributeErsteller" {
#   name = "Ersteller"
# }

# data "template_file" "userdataController" {
#   template = file("${path.module}/templates/userdataController.tftpl")
#   vars = {
#     no_proxy    = var.no_proxy
#     proxy       = var.proxy
#     reg_command = "${ran-cher2_cluster_v2.foo.cluster_registration_token.0.insecure_node_command} --etcd --controlplane --worker"
#   }
# }

# data "template_cloudinit_config" "userdataController" {
#   gzip          = false
#   base64_encode = false
#   part {
#     content_type = "text/cloud-config"
#     content      = data.template_file.userdataController.rendered
#   }
# }

# data "template_file" "metadata" {
#   count = var.masterCount
#   template = <<EOF
#     instance-id: "$${hostname}"
#     local-hostname: "$${hostname}"
#     network:
#       version: 1
#       config:
#         - type: physical
#           name: ens160
#           subnets:
#             - type: static
#               address: $${ipv4}/24
#               gateway: $${gwv4}
#               dns_nameservers:
#                 - $${dns1}
#                 - $${dns2}
#               dns_search:
#                 - maoam.hessen.de intern.hessen.de itshessen.hessen.de xad.hessen.de insm.hessen.de
#   EOF

#   vars = {
#     hostname = "${var.rke2ClusterName}-${var.hostnameMaster}-${count.index}"
#     ipv4 = var.ipv4
#     gwv4 = var.gwv4
#     dns1 = var.dns1
#     dns2 = var.dns2
#   }
# }
