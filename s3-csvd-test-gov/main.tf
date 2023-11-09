locals {
  base_tags = {
    "boc:tf_module_version" = local._module_version
    "boc:created_by"        = "terraform"
  }
}

resource "aws_s3_bucket" "csvd-test" {
  bucket = "csvd-test-for-morpheus"
  acl    = "private"

  tags = merge(
    local.base_tags,
    local.common_tags,
    var.tags,
    var.application_tags,
  )
}

resource "aws_kms_key" "csvd-test" {
  deletion_window_in_days = 30
  tags = merge(
    local.base_tags,
    local.common_tags,
    var.tags,
    var.application_tags,
  )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "myencryption" {
  bucket = aws_s3_bucket.csvd-test.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.csvd-test.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "myversion" {
  bucket = aws_s3_bucket.csvd-test.id
  versioning_configuration {
    status = "Enabled"
  }
}

