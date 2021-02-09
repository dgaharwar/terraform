/*
provider "aws" {
  assume_role {
    role_arn     = "arn:aws-us-gov:iam::861511318332:role/DMC3-Test_Terraform_Role"
  }
  region    = "us-gov-east-1"
}

provider "aws" {
  region     = "us-gov-west-1"
  access_key = ""   
  secret_key = ""
}

*/

provider "aws" {
  region     = "${var.region}" 
  access_key = "${var.access_key}"   
  secret_key = "${var.secret_key}"
}
