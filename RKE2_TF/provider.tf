terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    # vault = {
    #   source = "hashicorp/vault"
    # }
    # vsphere = {
    #   source = "hashicorp/vsphere"
    # }
  }
}

provider "rancher2" {
  api_url    = "https://rancherref.maoam.hessen.de"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  insecure   = true
}


# provider "vault" {
#   address         = "https://vaultref.maoam.hessen.de"
#   skip_tls_verify = true
# }

# provider "vsphere" {
#   vsphere_server       = "srvvchtestvc01.maoam.hessen.de"
#   allow_unverified_ssl = true
#   user                 = da-ta.vault_kv_secret_v2.vsphere_ref_rancher_serviceaccount.data["user"]
#   password             = da-ta.vault_kv_secret_v2.vsphere_ref_rancher_serviceaccount.data["password"]
# }
