terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = ">= 2"
    }
  }
}

provider "nutanix" {
  username     = var.nutanix_username
  password     = var.nutanix_password
  endpoint     = var.nutanix_endpoint
  port         = 9440
  insecure     = true
  wait_timeout = 10
}
