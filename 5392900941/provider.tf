terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = ">= 2"
    }
  }
}

provider "nutanix" {
  username     = var.username
  password     = var.password
  endpoint     = var.endpoint
  port         = var.port
  insecure     = true
  wait_timeout = 10
}
