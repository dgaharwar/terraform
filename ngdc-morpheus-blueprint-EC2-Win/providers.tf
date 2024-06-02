############################################################
#Provider
############################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

#  assume_role {
#    role_arn     = "arn:aws-us-gov:iam::${var.account_id}:role/NGDCMorpheusAdminRole"
#    session_name = "Morpheus_Terraform"
#  }
}
