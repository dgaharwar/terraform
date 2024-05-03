# output "cluster_registration_controller" {
#   value = re-place("${nonsensitive(rancher2_cluster_v2.foo.cluster_registration_token.0.insecure_node_command)} --etcd --controlplane", "\"", "'")
# }

# resource "local_file" "userdataController" {
#   content  = templatefile("${path.module}/templates/userdataController.tftpl", { proxy = var.proxy, no_proxy = var.no_proxy, reg_command = "${ran-cher2_cluster_v2.foo.cluster_registration_token.0.insecure_node_command} --etcd --controlplane" })
#   filename = "${path.module}/baked/user-data-controller.yaml"
# }

# output "cluster_registration_worker" {
#   value = re-place("${nonsensitive(rancher2_cluster_v2.foo.cluster_registration_token.0.insecure_node_command)} --worker", "\"", "'")
# }

# resource "local_file" "userdataWorker" {
#   content  = templatefile("${path.module}/templates/userdataWorker.tftpl", { proxy = var.proxy, no_proxy = var.no_proxy, reg_command = "${ran-cher2_cluster_v2.foo.cluster_registration_token.0.insecure_node_command} --worker" })
#   filename = "${path.module}/baked/user-data-worker.yaml"
# }
