#===============================================================================
# Global Varaibles
#===============================================================================
variable "aws_region" {
  description = "Provide the AWS region details"
  default = "us-east-2"
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

#===============================================================================
# Cluster Specs
#===============================================================================

variable "cluster_name" {
  description = "Name of EKS cluster"
  type    = string
}

variable "cluster_version" {
  description = "The cluster version"
  default = "1.18"
}

#=====================NodeGroup 1========================#
variable "cmp_primary_node_group" {
  description = "Name of Node Group"
  default     = "cmp-primary-ng"
}

variable "primary_nodes_disk_size" {
  default = 20
}
variable "desired_capacity_primary" {
  default     = 1
  type        = string
  description = "Autoscaling Desired node capacity"
}

variable "max_size_primary" {
  default     = 5
  type        = string
  description = "Autoscaling maximum node capacity"
}

variable "min_size_primary" {
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
#  default     = "cmp-secondary-ng"
#}

#variable "secondary_nodes_disk_size" {
#  default = 20
#}

#variable "desired_capacity_secondary" {
#  default     = 1
#  type        = string
#  description = "Autoscaling Desired node capacity"
#}

#variable "max_size_secondary" {
#  default     = 5
#  type        = string
#  description = "Autoscaling maximum node capacity"
#}

#variable "min_size_secondary" {
#  default     = 1
#  type        = string
#  description = "Autoscaling Minimum node capacity"
#}

#variable "cmp_secondary_instance_type" {
#  description = "instance type of worker"
#  default     = ["t3.medium"]
#}
#==========================================================#


variable "ec2_ssh_key" {
  description = "ssh key name for ec2 instance"
  default     = "k8s-jump"
}

#===============================================================================
# Network
#===============================================================================

variable "vpc_id" {
  description = "vpc id"
  type        = string
  default     = "vpc-015e2338b88b58b05"
}


variable "public_subnet_1" {  
  description = "public subnet id in  VPC"
  default     = "subnet-0c39c638c16a876e5"
}

variable "public_subnet_2" {  
  description = "public subnet id in  VPC"
  default     = "subnet-057ea7d3765d1c8a6"
}

variable "private_subnet_1" {
  description = "private subnet id in  VPC"
  default     = "subnet-0f6301f557340f13f"
}

variable "private_subnet_2" {
  description = "private subnet id in  VPC"
  default     = "subnet-0aa319f0b59e17e67"
}

variable "vpn_cidrs" {
  description = "Access from VPN"
  default     = "10.0.0.0/8"
}

#This is for Egress
variable "public_anywhere" {
  description = "Public access"
  default     = "0.0.0.0/0"
}
