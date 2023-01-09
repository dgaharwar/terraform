resource "morpheus_group" "tf_example_group" {
  name      = "<%= customOptions.clientName%>"
  code      = "<%= customOptions.clientName%>"
  location  = "denver"
  cloud_ids = [1]
}
