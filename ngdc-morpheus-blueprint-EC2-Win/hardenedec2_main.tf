locals {
  common_tags = {
    "Build Date"     = "${formatdate("MM/DD/YYYY", timestamp())}"
    "Build Engineer" = "${var.build_engineer_tag}"
    "Environment"    = "${var.environment_tag}"
    "Application"    = "${var.application_tag}"
    "Tracking ID"    = "${var.tracking_id_tag}"
  }


  ec2_tags = {
    "Name"        = "${var.hostname}"
    "Version"     = "${var.version_tag}"
    "VPC"         = "${var.vpc_tag}"
    "PII"         = "${var.pii_tag}"
    "Retention"   = "60"
    "Backup"      = "${var.backup_tag}"
    "Description" = "${var.instance_description_tag}"
    "Function"    = "${var.ec2_function_tag}"
    "Patch Group" = "${var.patch_group_tag}"
  }

  use_existing_eni = !var.create_eni
  private_ipv6     = var.private_ipv6 == "" ? [] : ["${var.private_ipv6}"]

  security_groups = [
    data.aws_security_group.windows_standard_sg.id,
    data.aws_security_group.windows_standard2_sg.id
  ]

  no_sg_attached              = local.use_existing_eni ? length(data.aws_network_interface.instance_eni[0].security_groups) < length(local.security_groups) ? true : false : false
  use_existing_admin_secret   = !var.create_admin_secret
  use_existing_keypair_secret = !var.create_keypair_secret

  drive_configuration = var.additional_drive_configuration != [] ? "${jsonencode(var.additional_drive_configuration)}" : ""
}



############################################################
#EC2 Key Pair
############################################################
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  depends_on = [tls_private_key.default]
  key_name   = "${var.hostname}-keypair"
  public_key = tls_private_key.default.public_key_openssh

  tags = merge(local.common_tags, {
    "Name"        = "${var.hostname}EC2KeyPair"
    "Description" = "${var.hostname}EC2KeyPair"
  })
}

resource "aws_secretsmanager_secret" "private_key_pem" {
  count = !local.use_existing_keypair_secret ? 1 : 0

  name                           = "/ngdcwindowskeypair/${var.hostname}"
  force_overwrite_replica_secret = var.secret_force_overwrite
  recovery_window_in_days        = var.secret_recovery_window

  tags = merge(local.common_tags, {
    "Name"        = "${var.hostname}-privatekey"
    "Description" = "${var.hostname} Private Key Material"
  })
}

resource "aws_secretsmanager_secret_version" "private_key_pem" {
  count = var.create_keypair_secret ? 1 : 0

  secret_id     = local.use_existing_keypair_secret ? data.aws_secretsmanager_secret.existing_keypair_secret[0].id : aws_secretsmanager_secret.private_key_pem[0].id
  secret_string = tls_private_key.default.private_key_pem
}

############################################################
#EBS KMS Key
############################################################
resource "aws_kms_key" "ebs_kms_key" {
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.ebs_key_policy.json

  tags = merge(local.common_tags, {
    "Name"        = "${var.hostname}KMSKey"
    "Description" = "${var.hostname}KMSKey"
  })
}

resource "aws_kms_alias" "ebs_kms_key_alias" {
  name          = "alias/${var.hostname}"
  target_key_id = aws_kms_key.ebs_kms_key.key_id
}

############################################################
#EC2 Windows 2022 Instance
############################################################
resource "aws_instance" "win22_instance" {
  ami = var.win22_ami

  get_password_data = true

  associate_public_ip_address = var.create_eni ? var.associate_public_ip_address : false
  instance_type               = var.instance_type
  disable_api_termination     = var.disable_api_termination
  key_name                    = aws_key_pair.generated_key.key_name
  iam_instance_profile        = var.instance_profile_name
  disable_api_stop            = var.disable_api_stop
  private_ip                  = var.create_eni ? var.private_ipv4 : ""
  ipv6_addresses              = var.create_eni ? local.private_ipv6 : []
  subnet_id                   = var.create_eni ? var.subnet_id : ""
  vpc_security_group_ids      = var.create_eni ? local.security_groups : []

  metadata_options {
    http_put_response_hop_limit = 2
    http_endpoint               = "enabled"
    http_tokens                 = "required"
  }

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.volume_type
    encrypted             = true
    kms_key_id            = aws_kms_key.ebs_kms_key.arn
    delete_on_termination = var.delete_on_termination
  }

  dynamic "ebs_block_device" {
    for_each = { 
      for key, drive in var.additional_drive_configuration :
      drive.name => drive
    }

    content {
      device_name           = ebs_block_device.value.name
      delete_on_termination = var.delete_on_termination
      kms_key_id            = aws_kms_key.ebs_kms_key.arn
      encrypted             = true
      volume_size           = ebs_block_device.value.size
      volume_type           = var.volume_type
    }
  }

  user_data = templatefile("user_data.ps1", {
    hostname                    = "${var.hostname}",
    net_adapter_name            = "${var.net_adapter_name}",
    domain_credential_secret_id = "${var.domain_credential_secret_id}",
    ad_domain_name              = "${var.ad_domain_name}",
    ad_availability_zone        = "${var.ad_availability_zone}",
    ad_environment              = "${var.ad_environment}",
    drive_configuration         = "${local.drive_configuration}"
  })

  tags = merge(local.common_tags, local.ec2_tags, {
    "Automation"      = var.automation_tag
    "Auto-Start-Stop" = var.autostartstop_tag
    "Auto-Start-Time" = var.autostarttime_tag
    "Auto-Stop-Time"  = var.autostoptime_tag
    "AZ"              = var.availability_zone_tag
  })

  dynamic "network_interface" {
    for_each = local.use_existing_eni ? toset(["existing"]) : toset([])

    content {
      device_index         = 0
      network_interface_id = data.aws_network_interface.instance_eni[0].id
    }
  }

  volume_tags = merge(local.common_tags, local.ec2_tags)

}


resource "aws_network_interface_sg_attachment" "security_group_attachments" {
  for_each = local.use_existing_eni && local.no_sg_attached ? toset(local.security_groups) : toset([])

  security_group_id    = each.key
  network_interface_id = data.aws_network_interface.instance_eni[0].id
}

resource "aws_secretsmanager_secret" "windows_admin_password" {
  count = !local.use_existing_admin_secret ? 1 : 0

  name                           = "/ngdcwindowsadminpass/${var.hostname}"
  force_overwrite_replica_secret = var.secret_force_overwrite
  recovery_window_in_days        = var.secret_recovery_window

  tags = merge(local.common_tags, {
    "Name"        = "${var.hostname}-admin-pass"
    "Description" = "${var.hostname} Administrator Password"
  })
}

resource "aws_secretsmanager_secret_version" "windows_admin_password" {
  count = var.create_admin_secret ? 1 : 0

  secret_id     = local.use_existing_admin_secret ? data.aws_secretsmanager_secret.existing_admin_secret[0].id : aws_secretsmanager_secret.windows_admin_password[0].id
  secret_string = rsadecrypt(aws_instance.win22_instance.password_data, tls_private_key.default.private_key_pem)
}


resource "aws_ssm_association" "install_cloudwatch_agent" {
  name = "AWS-ConfigureAWSPackage"

  targets {
    key    = "InstanceIds"
    values = ["${aws_instance.win22_instance.id}"]
  }

  parameters = {
    name   = "AmazonCloudWatchAgent"
    action = "Install"
  }
}
