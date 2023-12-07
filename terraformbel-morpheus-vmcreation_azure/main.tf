data "morpheus_tenant" "master_tenant" {
  name = "Morpheus"
}

data "morpheus_virtual_image" "azr_w2019_latest" {
  name = "dg-az-win2019"
}