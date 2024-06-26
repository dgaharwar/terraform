data "aws_security_group" "windows_standard_sg" {
  id = "sg-2b299333"
}

data "aws_security_group" "windows_standard2_sg" {
  id = "sg-00c2b0b7b7d5e596d"
}

#data "aws_security_group" "windows_standard_sg" {
#  tags = {
#    Name = "vpc-33ac354e"
#  }
#}

#data "aws_security_group" "windows_standard2_sg" {
#  tags = {
#    Name = "launch-wizard-1"
#  }
#}

data "aws_secretsmanager_secret" "existing_keypair_secret" {
  count = !var.create_keypair_secret ? 1 : 0

  name = "/ngdcwindowskeypair/${var.hostname}"
}

data "aws_secretsmanager_secret" "existing_admin_secret" {
  count = !var.create_admin_secret ? 1 : 0

  name = "/ngdcwindowsadminpass/${var.hostname}"
}

data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.vpc_name}"
  }
}

data "aws_network_interface" "instance_eni" {
  count = local.use_existing_eni ? 1 : 0

  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.vpc.id}"]
  }

  filter {
    name   = "addresses.private-ip-address"
    values = ["${var.private_ipv4}"]
  }
}


data "aws_iam_policy_document" "ebs_key_policy" {
  policy_id = "ebs-kms-policy"

  statement {

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }

    effect = "Allow"

    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt*",
      "kms:Encrypt*",
      "kms:ReEncrypt*",
      "kms:Describe*",
      "kms:Put*",
      "kms:Get*",
      "kms:List*",
      "kms:EnableKeyRotation",
      "kms:ScheduleKeyDeletion",
      "kms:CreateAlias",
      "kms:DeleteAlias",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:CreateGrant"
    ]

    resources = ["*"]
  }
}
