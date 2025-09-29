variable "cluster" {
  description = "Choose Cluster"
  type        = string
}

variable "nutanix_username" {
  description = "Nutanix user"
  type        = string
  sensitive   = true
}

variable "nutanix_password" {
  description = "Nutanix password"
  type        = string
  sensitive   = true
}

variable "nutanix_imagename" {
  description = "Name of image for VM"
  type        = string
  sensitive   = false
}

variable "vm_name" {
  description = "Nutanix VM name van VM in CAPITALS"
  type = string
  sensitive   = false
}

variable "vm_categories" {
  description = "Een string van categorien in key/value split op comma"
  type = string
}
