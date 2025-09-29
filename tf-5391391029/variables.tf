#variable "cloud" {
#  description = "Glue: Choose Cloud file"
#  type        = string
#}

variable "cluster" {
  description = "Choose Cluster"
  type        = string
}

#variable "vlan" {
#  description = "vlan"
#  type        = string
#}

#variable "hostname" {
#  description = "hostnaam van VM in lower case"
#  type = string
#  sensitive   = false
#}

variable "vm_categories" {
  description = "Een string van categorien in key/value split op comma"
  type = string
}

#variable "boot_type" {
#  description = "Nutanix VM Boottype"
#  type = string
#  default = "UEFI" # or "SECURE_BOOT"
#}

#variable "nutanix_machine_type" {
#  description = "Nutanix VM machine_type"
#  type        = string
#  default     = "Q35"
#  sensitive   = false
#}

#variable "storagecontainer" {
#   description = "Naam van de storagecontainer welke je wil gebruiken"
#   type = string
#   default = "SelfServiceContainer"

#variable "dns_domain" {
#  description = "DNS domein"
#  type = string
#}

#variable "ntp_server" {
#  description = "NTP server"
#  type = string
#}

variable "unattend" {
  description = "Windows unattend.xml filenaam"
  type = string
}

#variable "infoblox_username" {
#  description = "Infoblox user"
#  type        = string
#  sensitive   = true
#}

#variable "infoblox_password" {
#  description = "Infoblox password"
#  type        = string
#  sensitive   = true
#}

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

#variable "vm_description" {
#  description = "VM description"
#  type = string
#  sensitive   = false
#}

variable "vm_name" {
  description = "Nutanix VM name van VM in CAPITALS"
  type = string
  sensitive   = false
}

variable "nutanix_imagename" {
  description = "Name of image for VM"
  type        = string
  sensitive   = false
}

#variable "windows_admin_username" {
#  description = "Name of domain for VMs"
#  type        = string
#  sensitive   = false
#  #default     = "Administrator"
#}

#variable "windows_admin_password" {
#  description = "Name of domain for VMs"
#  type        = string
#  sensitive   = true
#  #default     = ""
#}

#variable "windows_admin_unenc" {
#  description = "Unencrypted pwd"
#  type        = string
#  sensitive   = true
#  #default     = ""
#}

#variable "num_vcpus_per_socket" {
#  description = "Nutanix VM vCores per socket, laat deze op 1 staan voor hot_add"
#  type = string
#  default = "1"
#}

#variable "num_sockets" {
#  description = "Nutanix VM vCPU's"
#  type = string
#  default = "2"
#}

#variable "memory_size_mib" {
#  description = "Nutanix VM vMEM"
#  type = string
#  default = "2048"
#}

#variable "extradisksizes" {
#  description = "komma gescheiden variabele met extra disken in GB"
#  type = string
#}

#variable "infoblox_endpoint" {
#  description = "Infoblox IP adres"
#  type = string
#}

#variable "ipv4_nameservers" {
#  description = "IPv4 nameserver IP adres"
#  type = string
#}

#variable "os_type" {
#  description = "OS Type redhat or windows"
#  type = string
#}

variable "cloud_init" {
  description = "Linux cloud init filenaam"
  type = string
}

