provider "vault" {
  # It is strongly recommended to configure this provider through the
  # environment variables described above, so that each user can have
  # separate credentials set in the environment.
  #
  # This will default to using $VAULT_ADDR
  # But can be set explicitly
  address = var.tf_vault_url
  #
  # This will default to using ~/.vault-token
  # But can be set explicitly
  token = var.tf_vault_token
  skip_tls_verify = true
}

data "vault_generic_secret" "morpheus" {
  path = "infra_core/kv/tools/morpheus"
}

provider "morpheus" {
  url      = data.vault_generic_secret.morpheus.data.address
  access_token = data.vault_generic_secret.morpheus.data.access_token
  #username = data.vault_generic_secret.morpheus.data.user
  #password = data.vault_generic_secret.morpheus.data.pw
}
