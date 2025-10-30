variable "nutanix_username" {
  type = string
}

variable "nutanix_password" {
  type = string
}

variable "nutanix_endpoint" {
  type = string
}

variable "vm_name" {
  type    = string
  default = ""
}

variable "nutanix_imagename" {
  type    = string
  default = ""
