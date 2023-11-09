# variables.common.tf
# applies to all resources in this account

#---
# profile and region
#---
variable "profile" {
  description = "AWS config profile"
  type        = string
  default     = ""
}

#variable "region" {
#  description = "AWS region"
#  type        = string
#  default     = ""
#}

variable "regions" {
  description = "AWS regions under which this configuration is used (for region-specific setup)"
  type        = list(string)
  default     = []
}

# split for two regions, so we can do both east and west
variable "region_map" {
  description = "AWS region map"
  type        = map(string)
  default = {
    "west" = "us-west-1"
    "east" = "us-east-1"
  }
}

variable "aws_environment" {
  description = "AWS Environment (govcloud | east-west)"
  type        = string
  default     = ""
}

# get this from caller arn instead
#variable "aws_arn_partition" {
#  description = "AWS Partition (aws or aws-us-gov)"
#  default = ""
#}

#---
# account info
#---
variable "account_id" {
  description = "AWS Account ID"
  type        = string
  default     = ""
}

variable "account_alias" {
  description = "AWS Account Alias"
  type        = string
  default     = ""
}

data "aws_caller_identity" "current" {}

data "aws_arn" "current" {
  arn = data.aws_caller_identity.current.arn
}

data "aws_region" "current" {}

# output "caller_account_id" {
#   value = data.aws_caller_identity.current.account_id
# }
# 
# output "account_caller_arn" {
#   value = data.aws_caller_identity.current.arn
# }
# 
# output "account_caller_arn_partition" {
#   value = data.aws_arn.current.partition
# }

variable "vpc_full_name" {
  description = "Full name component used through the VPC"
  type        = string
  default     = ""
}

variable "census_public_cidr" {
  description = "I am some dummy text"
  type        = list(string)
  default     = ["XXX.XXX.X.X/16"]
}

#---
# tags
#---
variable "tag_creator" {
  description = "Tag Creator (default)"
  type        = string
  default     = "dummyvalue"
}

variable "tag_costallocation" {
  description = "Tag CostAllocation (default)"
  type        = string
  default     = "mytag:sometag"
  #  default     = "test"
}

locals {
  common_tags = {
    Environment    = "infrastructure"
    CostAllocation = var.tag_costallocation
    #    Creator          = var.tag_creator
    "boc:created_by" = "terraform"
  }
}
