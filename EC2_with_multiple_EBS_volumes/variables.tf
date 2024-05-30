variable "region" {
  description = "The AWS region to create resources in"
}

variable "access_key" {
  description = "The Access Key for the user to authenticate"
}

variable "secret_key" {
  description = "The Secret Key for the user to authenticate"
}

variable "ami" {
  description = "The AMI ID to use for the instance"
  default     = "ami-0e001c9271cf7f3b9"
}

variable "instance_type" {
  description = "The type of instance to create"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key pair name to use for the instance"
  default     = "MorpheusApp"
}

variable "volume_type" {
  description = "The type of EBS volume"
  default     = "gp2"
}

variable "delete_on_termination" {
  description = "Whether the volume should be deleted on instance termination"
  default     = true
}

variable "root_volume_size" {
  description = "The size of the root volume"
  default     = 8
}

variable "additional_drive_configuration" {
  description = "Configuration for additional EBS volumes"
  type        = list(object({
    name         = string
    size         = number
    drive_letter = string
    drive_name   = string
  }))
  default = []
}
