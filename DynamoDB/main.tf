#version.tf
terraform {
  # https://github.com/hashicorp/terraform/releases/tag/v1.6.6
  required_version = ">= 1.6"
 
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # https://github.com/hashicorp/terraform-provider-aws/releases/tag/v5.27.0
      version = ">= 4.29.0"
    }
  }
}

provider "aws" {
    region     = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_dynamodb_table" "this" {
  count = var.create_table && !var.autoscaling_enabled ? 1 : 0
 
  name             = var.name
  billing_mode     = var.billing_mode
  hash_key         = var.hash_key
  range_key        = var.range_key
  read_capacity    = var.read_capacity
  write_capacity   = var.write_capacity
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type
  table_class      = var.table_class
 
  ttl {
    enabled        = var.ttl_enabled
    attribute_name = var.ttl_attribute_name
  }
 
  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }
 
  dynamic "attribute" {
    for_each = var.attributes
 
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }
 
  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
 
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
    }
  }
 
  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
 
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      projection_type    = global_secondary_index.value.projection_type
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
    }
  }
 
  dynamic "replica" {
    for_each = var.replica_regions
 
    content {
      region_name            = replica.value.region_name
      kms_key_arn            = lookup(replica.value, "kms_key_arn", null)
      propagate_tags         = lookup(replica.value, "propagate_tags", null)
      point_in_time_recovery = lookup(replica.value, "point_in_time_recovery", null)
    }
  }
 
  server_side_encryption {
    enabled     = var.server_side_encryption_enabled
    kms_key_arn = var.server_side_encryption_kms_key_arn
  }
 
  tags = merge(
    var.tags,
    {
      "Name" = format("%s", var.name)
    },
  )
 
  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }
}
 
resource "aws_dynamodb_table" "autoscaled" {
  count = var.create_table && var.autoscaling_enabled ? 1 : 0
 
  name             = var.name
  billing_mode     = var.billing_mode
  hash_key         = var.hash_key
  range_key        = var.range_key
  read_capacity    = var.read_capacity
  write_capacity   = var.write_capacity
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type
  table_class      = var.table_class
 
  ttl {
    enabled        = var.ttl_enabled
    attribute_name = var.ttl_attribute_name
  }
 
  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }
 
  dynamic "attribute" {
    for_each = var.attributes
 
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }
 
  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
 
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
    }
  }
 
  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
 
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      projection_type    = global_secondary_index.value.projection_type
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
    }
  }
 
  dynamic "replica" {
    for_each = var.replica_regions
 
    content {
      region_name            = replica.value.region_name
      kms_key_arn            = lookup(replica.value, "kms_key_arn", null)
      propagate_tags         = lookup(replica.value, "propagate_tags", null)
      point_in_time_recovery = lookup(replica.value, "point_in_time_recovery", null)
    }
  }
 
  server_side_encryption {
    enabled     = var.server_side_encryption_enabled
    kms_key_arn = var.server_side_encryption_kms_key_arn
  }
 
  tags = merge(
    var.tags,
    {
      "Name" = format("%s", var.name)
    },
  )
 
  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }
 
  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }
}


#variable.tf
## REQUIRED VARIABLES
variable "create_table" {
  description = "Controls if DynamoDB table and associated resources are created"
  type        = bool
  default     = true
}
 
variable "name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = null
}
 
variable "attributes" {
  description = "List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
  type        = list(map(string))
  default     = []
}
 
variable "hash_key" {
  description = "The attribute to use as the hash (partition) key. Must also be defined as an attribute"
  type        = string
  default     = null
}
 
variable "range_key" {
  description = "The attribute to use as the range (sort) key. Must also be defined as an attribute"
  type        = string
  default     = null
}
 
variable "billing_mode" {
  description = "Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY_PER_REQUEST"
  type        = string
  default     = "PAY_PER_REQUEST"
}
 
variable "write_capacity" {
  description = "The number of write units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = null
}
 
variable "read_capacity" {
  description = "The number of read units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = null
}
 
variable "point_in_time_recovery_enabled" {
  description = "Whether to enable point-in-time recovery"
  type        = bool
  default     = false
}
 
variable "ttl_enabled" {
  description = "Indicates whether ttl is enabled"
  type        = bool
  default     = false
}
 
variable "ttl_attribute_name" {
  description = "The name of the table attribute to store the TTL timestamp in"
  type        = string
  default     = ""
}
 
variable "global_secondary_indexes" {
  description = "Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc."
  type        = any
  default     = []
}
 
variable "local_secondary_indexes" {
  description = "Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource."
  type        = any
  default     = []
}
 
variable "replica_regions" {
  description = "Region names for creating replicas for a global DynamoDB table."
  type        = any
  default     = []
}
 
variable "stream_enabled" {
  description = "Indicates whether Streams are to be enabled (true) or disabled (false)."
  type        = bool
  default     = false
}
 
variable "stream_view_type" {
  description = "When an item in the table is modified, StreamViewType determines what information is written to the table's stream. Valid values are KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES."
  type        = string
  default     = null
}
 
variable "server_side_encryption_enabled" {
  description = "Whether or not to enable encryption at rest using an AWS managed KMS customer master key (CMK)"
  type        = bool
  default     = false
}
 
variable "server_side_encryption_kms_key_arn" {
  description = "The ARN of the CMK that should be used for the AWS KMS encryption. This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb."
  type        = string
  default     = null
}
 
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
 
variable "timeouts" {
  description = "Updated Terraform resource management timeouts"
  type        = map(string)
  default = {
    create = "10m"
    update = "60m"
    delete = "10m"
  }
}
 
variable "autoscaling_enabled" {
  description = "Whether or not to enable autoscaling. See note in README about this setting"
  type        = bool
  default     = false
}
 
variable "autoscaling_defaults" {
  description = "A map of default autoscaling settings"
  type        = map(string)
  default = {
    scale_in_cooldown  = 0
    scale_out_cooldown = 0
    target_value       = 70
  }
}
 
variable "autoscaling_read" {
  description = "A map of read autoscaling settings. `max_capacity` is the only required key. See example in examples/autoscaling"
  type        = map(string)
  default     = {}
}
 
variable "autoscaling_write" {
  description = "A map of write autoscaling settings. `max_capacity` is the only required key. See example in examples/autoscaling"
  type        = map(string)
  default     = {}
}
 
variable "autoscaling_indexes" {
  description = "A map of index autoscaling configurations. See example in examples/autoscaling"
  type        = map(map(string))
  default     = {}
}
 
variable "table_class" {
  description = "The storage class of the table. Valid values are STANDARD and STANDARD_INFREQUENT_ACCESS"
  type        = string
  default     = null
}

variable "region" {}
variable "access_key" {}
variable "secret_key" {}

 
#.tfvars
create_distribution = true
 
origin = {
  "example-origin-1" = {
    domain_name  = "example-bucket.s3.amazonaws.com"
    # s3_origin_config = {
    #   cloudfront_access_identity_path = "origin-access-identity/cloudfront/E1234567890"
    # }
  }
}
 
geo_restriction = {
  restriction_type = "whitelist"
  locations = ["US", "CA"]
}
 
 
default_cache_behavior = {
  target_origin_id       = "example-origin-1"
  viewer_protocol_policy = "redirect-to-https"
}
 
# viewer_certificate = {
#   acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abcd-1234-efgh-5678"
#   cloudfront_default_certificate = false
#   minimum_protocol_version = "TLSv1.2_2019"
#   ssl_support_method       = "sni-only"
# }
 
origin_access_identities = {
  "example-identity" = "My CloudFront Origin Access Identity"
}
 
create_origin_access_identity = true
create_origin_access_control  = true