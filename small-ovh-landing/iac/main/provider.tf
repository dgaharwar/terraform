terraform {
  # Need for_each on providers, available in OpenTofu v1.9.0
  required_version = ">= 1.9.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~> 2.6"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
  }
}

provider "ovh" {
  endpoint = "ovh-eu"

  application_key    = var.ovh_access_token.app_key
  application_secret = var.ovh_access_token.app_secret
  consumer_key       = var.ovh_access_token.consumer_key
}

provider "openstack" {
  auth_url  = "https://auth.cloud.ovh.net/"
  region    = var.ovh_region
  user_name = var.project_user_username
  password  = var.project_user_password
  tenant_id = var.project_id
}
