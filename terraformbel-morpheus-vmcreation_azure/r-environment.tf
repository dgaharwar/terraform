locals {
  environments = {
    "PRODUCTION"="production",
    "Staging"="staging",
    "Test"="qa",
    "Dev"="dev"
  }
}
resource "morpheus_environment" "env" {
  for_each = local.environments
  active      = true
  code        = each.value
  description = "managed by terraform"
  name        = each.key
}