variable "credentials" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "app_name" {
  type        = string
  description = "Friendly name for your application resources"
}

variable "network_id" {
  type        = string
  description = "Id of the network to place the virtual machine"
}

variable "subnetwork_id" {
  type        = string
  description = "Id of the subnetwork within the network to place the virtual machine"
}

variable "instance_type" {
  type        = string
  description = "Instance type of the virtual machine"
}

variable "instance_volume_size" {
  type        = string
  description = "Instance size of the virtual machine"
}

variable "admin_user" {
  type        = string
  description = "Admin user name to access the virtual machine"
}

variable "public_key" {
  type        = string
  description = "Public key to be associated with the virtual machine"
}

variable "assign_public_ip" {
  type    = bool
  default = true
}
