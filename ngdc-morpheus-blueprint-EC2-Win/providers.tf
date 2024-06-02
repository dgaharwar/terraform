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

  assume_role {
    role_arn     = "arn:aws-us-gov:iam::${var.account_id}:role/NGDCMorpheusAdminRole"
    session_name = "Morpheus_Terraform"
  }
}
