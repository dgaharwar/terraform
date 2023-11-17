variable "vm_size" {
  type = string
  description = "The size of the virtual machine"
  default = "Standard_B1s"
}

variable "location" {
  type        = string
  description = "The Azure region where the virtual machine will be created"
  default     = "Central US"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the virtual machine will be created"
  default     = "rmg-ops"
}

variable "disk_type" {
  description = "The size of the virtual machine"
  default     = "Standard_LRS"
}

variable "os_image" {
  default     = "win10-22h2-pro-g2"
  description = "Variable to pick an OS flavour for Windows based VM. Possible values include: winserver, wincore, winsql"
}

variable "vm_name"{
  type = string
  default = "dg-windowsvm-tf"
}

variable "admin_username"{
  type = string
  default = "deepti"
}

variable "admin_password" {
  type = string
  default = "Password123?"
}

variable "windowsvm_caching" {
  type     = string
  default  = "ReadWrite"
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}



