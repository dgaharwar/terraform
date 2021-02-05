resource "random_string" "password" {
  length           = 10
  special          = false
  override_special = "*&^$!#@"        #pufV#YiC!@
}

locals {
  var_iops = {
    value = max(4000, var.max_allocated_storage)
  }
}

locals {
  var_storage = {
    value = max(var.allocated_storage, (var.max_allocated_storage*0.02))
  }
}


data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com", "rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_iam_role" {
  name               = format("%s-rds-iam-role", lower(var.db_name))
  assume_role_policy = data.aws_iam_policy_document.enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
    role       = "${aws_iam_role.rds_iam_role.name}"
    policy_arn = "arn:aws-us-gov:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_subnet_group" "group" {
  name       = format("%s-sngrp", lower(var.db_name))
  subnet_ids = ["${var.vpc_subnet_az1}", "${var.vpc_subnet_az2}"]
  tags = {
    Name = "${var.db_name} DB subnet group"
    Author = "Effectual Terraform script"
    Date = "${timestamp()}"
  }
}

data "aws_subnet" "this_subnet" {
  id = var.vpc_subnet_az1
}

data "aws_vpc" "selected" {
  id = "${data.aws_subnet.this_subnet.vpc_id}"
}

resource "aws_security_group" "db_sg" {
  name        = format("%s_rds-sg", lower(var.db_name))
  description = "${var.db_name} Database security group"
  vpc_id      = "${data.aws_subnet.this_subnet.vpc_id}"
  ingress {
    description = "Port for RDS Oracle Database"
    from_port   = "${var.db_port}"
    to_port     = "${var.db_port}"
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.selected.cidr_block}", var.workspaces_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.db_name} Database Security Group"
    Author = "Effectual Terraform script"
    Date = "${timestamp()}"
  }
}

resource "aws_db_instance" "new_db" {
  identifier                  = lower(var.db_name)
  name                        = null #lower(var.db_name)
  multi_az                    = true
  allocated_storage           = local.var_storage.value     #"${var.allocated_storage}"
  max_allocated_storage       = "${var.max_allocated_storage}"
  storage_type                = "${var.storage_type}" 
  iops                        = local.var_iops.value
#  storage_encrypted           = true
  port                        = "${var.db_port}"
  backup_retention_period     = var.backup_retention_period
  backup_window               = "${var.backup_window}"
  maintenance_window          = "${var.maintenance_window}"
  copy_tags_to_snapshot       = true
  monitoring_interval         = 1
  monitoring_role_arn         = "${aws_iam_role.rds_iam_role.arn}"
  enabled_cloudwatch_logs_exports = ["agent", "error"] 
  engine                      = "${var.engine_name}"
  engine_version              = "${var.engine_version}"
  character_set_name          = "${var.character_set_name}"
  instance_class              = "${var.instance_class}"
  db_subnet_group_name        = "${aws_db_subnet_group.group.id}"
  vpc_security_group_ids      = ["${aws_security_group.db_sg.id}"]
  publicly_accessible         = false
  allow_major_version_upgrade = false
  apply_immediately           = false
  auto_minor_version_upgrade  = false
  deletion_protection         = false
  delete_automated_backups    = true
  parameter_group_name        = "${aws_db_parameter_group.default.id}"  
  option_group_name           = "${aws_db_option_group.db_group.name}"
  username                    = lower(var.db_name)    
  password                    = "${random_string.password.result}"
  skip_final_snapshot         = true #for testing purposes
 # snapshot_identifier         = "rds:${var.db_name}-snapshot-01"
  license_model               = "license-included"
  tags = {
          Name = "${join("-", ["${var.db_name}", "${var.client}", "RDS"])}"
          Environment = "${var.environment}"
          Author = "Effectual Terraform script"
          Date = "${timestamp()}"
         }
         
  timeouts {
     create = "60m"
  }
}

/**
  Parameter Group
*/
resource "aws_db_parameter_group" "default" {
  name        = format("%s-pg", lower(var.db_name))
  description = format("Parameter group for %s", var.db_name)
  family      = "${var.family}"

  lifecycle {
    create_before_destroy = true
  }
  
  tags = {
    Author = "Effectual Terraform script"
    Date = "${timestamp()}"
  } 

}

/**
  Options group
*/
resource "aws_db_option_group" "db_group" {
  name                     = format("%s-og", lower(var.db_name))
  option_group_description = format("Option group for %s", var.db_name)
  engine_name              = var.engine_name
  major_engine_version     = var.major_engine_version

  lifecycle {
    create_before_destroy = true
  }
  
  tags = {
    Author = "Effectual Terraform script"
    Date = "${timestamp()}"
  } 
}

 