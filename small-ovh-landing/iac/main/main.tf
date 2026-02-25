module "user_project" {
  source = "./modules/users"
  # source     = "git::https://morpheus-sensitive-int-mastertenant-ovhlanding:glpat-Y7cYt1vr9Hv90AOGjoQaiG86MQp1OjhtCA.01.0y1k5yq53@gitlab.apsys-airbus.com/oneplatform/clouds/small-ovh-landing.git//modules/users?ref=MAGL/integration-morpheus2"
  project_id = var.project_id
  #roles      = ["administrator"]
}

data "openstack_images_image_v2" "images" {
  for_each      = toset(concat([for v in var.vms : v.os_image if v.os_image != "" && v.os_image != null], [var.default_os_image]))
  name          = each.value
  most_recent   = true
  member_status = "all"
  depends_on    = [module.user_project]
}


resource "openstack_compute_keypair_v2" "iaas_keypair" {
  name       = "test-key"
  public_key = var.public_key
  depends_on = [module.user_project]
}

resource "openstack_images_image_access_accept_v2" "accepted_images" {
  for_each   = data.openstack_images_image_v2.images
  image_id   = each.value.id
  status     = "accepted"
  depends_on = [module.user_project]
}
