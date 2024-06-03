####################################################################################
#Provider 
####################################################################################
variable "region" {
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "account_id" {
  type = string
  default = "402420433104"
}


#EC2 Config #################################################################################

variable "vpc_name" {
  type = string
}

variable "win22_ami" {
  type    = string
  default = "ami-0069eac59d05ae12b"
}

variable "hostname" {
  type = string
}

variable "private_ipv4" {
  type    = string
  default = ""
}

variable "private_ipv6" {
  type    = string
  default = ""
}

variable "net_adapter_name" {
  type = string
  description = "Name to rename the NIC to"
}

variable "subnet_id" {
  type = string
}

variable "ad_domain_name" {
  type    = string
  default = "fsa.mrd"
  description = "AD Domain to join"
}

variable "ad_environment" {
  type        = string
  description = "OU to place new instance in. eg. Prod, NonProd, MGMT"

  # validation {
  #   condition     = contains(["Prod", "NonProd", "MGMT"], var.ad_environment)
  #   error_message = "Value must be 'Prod', 'NonProd', 'MGMT'"
  # }
}

variable "ad_availability_zone" {
  type        = string
  description = "AZ instance lives in. eg. AZ1, AZ2"

  # validation {
  #   condition     = contains(["AZ1", "AZ2"], var.ad_availability_zone)
  #   error_message = "Value must be 'AZ1', 'AZ2'"
  # }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type. eg. t3.large"
}

variable "instance_profile_name" {
  type        = string
  description = "Instance Profile to associate with the new instance"
}

variable "root_volume_size" {
  type    = string
  default = "100"
  description = "Size of the C: Drive"
}

variable "volume_type" {
  type    = string
  default = "gp3"
  description = "Storage type eg. gp2, gp3"
}

variable "delete_on_termination" {
  type    = bool
  default = "true"
  description = "Delete associated EBS Volumes on instance termination"
}

variable "create_eni" {
  type    = bool
  default = "false"
  description = "Defines whether or not to create an ENI or use an existing ENI"
}

variable "associate_public_ip_address" {
  type    = bool
  default = "true"
  description = "Defines whether or not to associate a public IP address. Only used in Public Subnets"
}

#endregion EC2 Config

#region Secret Manager Secrets #####################################################################
variable "secret_force_overwrite" {
  type    = bool
  default = "true"
}

variable "secret_recovery_window" {
  type    = string
  default = "0"
}

variable "create_admin_secret" {
  type    = bool
  default = "true"
}

variable "create_keypair_secret" {
  type    = bool
  default = "true"
}

variable "domain_credential_secret_id" {
  type    = string
  default = "arn:aws:secretsmanager:us-east-1:402420433104:secret:DGMorph/Secret-vhzBJG"
}

#endregion Secret Manager Secrets

#region Additional Settings and EBS Volumes ########################################################

variable "additional_drive_configuration" {
  type = list(object({
    name         = string
    size         = string
    drive_letter = string
    drive_name   = string
  }))

  default     = []
  description = "list of drive configurations eg. [{\"name\"=\"xvdf\", \"size\" = \"100\", \"drive_letter\" = \"D\", \"drive_name\" = \"DATA\" }] "
}

variable "disable_api_termination" {
  type    = bool
  default = "true"
  description = "Turns EC2 Termination Protection On or Off."
}

variable "disable_api_stop" {
  type    = bool
  default = "false"
  description = "Turns EC2 Stop Protection On or Off."
}


#endregion Additional Settings and EBS Volumes

#region Standard Tags ##############################################################################

variable "build_date_tag" {
  type = string
  default = "No"
}

variable "build_engineer_tag" {
  type = string
  default = "No"
}

variable "environment_tag" {
  type = string
  default = "No"
}

variable "application_tag" {
  type = string
  default = "No"
}

variable "tracking_id_tag" {
  type = string
  default = "No"
}

variable "version_tag" {
  type    = string
  default = "Windows 2022 Server"
}

variable "vpc_tag" {
  type = string
  default = "No"
}

variable "pii_tag" {
  type = string
  default = "No"
}

variable "backup_tag" {
  type    = string
  default = "No"
}

variable "instance_description_tag" {
  type = string
  default = "No"
}

variable "ec2_function_tag" {
  type = string
  default = "No"
}

variable "patch_group_tag" {
  type = string
  default = "No"
}

variable "automation_tag" {
  type    = string
  default = "No"
}

variable "autostartstop_tag" {
  type    = string
  default = "No"
}

variable "autostarttime_tag" {
  type    = string
  default = "No"
}

variable "autostoptime_tag" {
  type    = string
  default = "No"
}

variable "availability_zone_tag" {
  type = string
  default = "No"
}

#endregion Standard Tags
