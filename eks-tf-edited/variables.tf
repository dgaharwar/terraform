#===============================================================================
# Global Varaibles
#===============================================================================
variable "aws_region" {
  default = "us-east-1"
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

#===============================================================================
# Cluster Specs
#===============================================================================

variable "cluster_name" {
  type    = string
  default = "dg-cmp-eks-dev"
}

variable "cluster_version" {
  default = "1.29"
}

#=====================NodeGroup 1========================#
variable "cmp_primary_node_group" {
  description = "Name of Node Group"
  default     = "dg-cmp-primary-ng"
}

variable "primary_nodes_disk_size" {
  default = 20
}
variable "desired-capacity-primary" {
  default     = 1
  type        = string
  description = "Autoscaling Desired node capacity"
}

variable "max-size-primary" {
  default     = 5
  type        = string
  description = "Autoscaling maximum node capacity"
}

variable "min-size-primary" {
  default     = 1
  type        = string
  description = "Autoscaling Minimum node capacity"
}

variable "cmp_primary_instance_type" {
  description = "instance type of worker"
  default     = "t3.medium"
}


#=====================NodeGroup 2========================#
#variable "cmp_secondary_node_group" {
#  description = "Name of Node Group"
#  default     = "dg-cmp-secondary-ng"
#}

#variable "secondary_nodes_disk_size" {
#  default = 20
#}

#variable "desired-capacity-secondary" {
#  default     = 1
#  type        = string
#  description = "Autoscaling Desired node capacity"
#}

#variable "max-size-secondary" {
#  default     = 5
#  type        = string
#  description = "Autoscaling maximum node capacity"
#}

#variable "min-size-secondary" {
#  default     = 1
#  type        = string
#  description = "Autoscaling Minimum node capacity"
#}

#variable "cmp_secondary_instance_type" {
#  description = "instance type of worker"
#  default     = ["t2.medium"]
#}
#==========================================================#


variable "ec2_ssh_key" {
  description = "ssh key name for ec2 instance"
  default     = "MorpheusApp"
}

#===============================================================================
# Network
#===============================================================================

variable "vpc_id" {
  description = "vpc id"
  type        = string
  default     = "vpc-33ac354e"
}


variable "public_subnet_1" {  
  description = "public subnet id in  VPC"
  default     = "subnet-12e7ae4d"
}

#variable "public_subnet_2" {  
#  description = "public subnet id in  VPC"
#  default     = "subnet-37a1ea16"
#}

variable "private_subnet_1" {
  description = "private subnet id in  VPC"
  default     = "subnet-03b9ce9725230b022"
}

variable "private_subnet_2" {
  description = "private subnet id in  VPC"
  default     = "subnet-565eea09"
}

variable "vpn_cidrs" {
  description = "Access from VPN"
  default     = "171.31.0.0/20"
}

#This is for Egress
variable "public_anywhere" {
  description = "Public access"
  default     = "0.0.0.0/0"
}
