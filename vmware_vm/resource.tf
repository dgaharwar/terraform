resource "morpheus_group" "morpheusgroup" {
  name      = "tfgroup"
  code      = "tfgroup"
  location  = "denver"
  cloud_ids = [1]
}
