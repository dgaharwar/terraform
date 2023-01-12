variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "gcp_private_key" { 
  type = string 
} 

variable "gcp_cred" { 
  type = map 
} 

locals {
  credential = merge(var.gcp_cred, {private_key = "${var.gcp_private_key}"}) 
}