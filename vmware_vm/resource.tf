resource "morpheus_group" "tf_example_group" {
  name      = var.tf_client_name
  code      = var.tf_client_name
  location  = "denver"
  cloud_ids = [3]
}
