variable "aws_region" {}
variable "aws_secret_key" {}
variable "aws_access_key" {}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }
  }
  required_version = ">= 0.14"
}
