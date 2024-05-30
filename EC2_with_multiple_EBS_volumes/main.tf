provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "dg_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "<%=customOptions.instanceName%>"
  }

  dynamic "ebs_block_device" {
    for_each = { for key, drive in var.additional_drive_configuration : drive.name => drive }

    content {
      device_name           = ebs_block_device.value.name
      volume_size           = ebs_block_device.value.size
      volume_type           = var.volume_type
      delete_on_termination = var.delete_on_termination
      kms_key_id            = aws_kms_key.ebs_kms_key.arn
      encrypted             = true
    }
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.volume_type
  }
}

resource "aws_kms_key" "ebs_kms_key" {
  description             = "KMS key for EBS volume encryption"
  deletion_window_in_days = 10
}
