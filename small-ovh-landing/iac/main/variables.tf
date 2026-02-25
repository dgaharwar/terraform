variable "ovh_access_token" {
  type = object({
    app_key      = string
    app_secret   = string
    consumer_key = string
  })
  description = "OVH API application key/secret and consumer key. Created using [https://www.ovh.com/auth/api/createToken?GET=/*&POST=/cloud/project/3119ad56589a4417a0c28dabd237878b/user*&PUT=/cloud/project/3119ad56589a4417a0c28dabd237878b/user*&DELETE=/cloud/project/3119ad56589a4417a0c28dabd237878b/user*&DELETE=/cloud/project/3119ad56589a4417a0c28dabd237878b/region/GRA11/gateway*&POST=/cloud/project/3119ad56589a4417a0c28dabd237878b/region/GRA11/network/*]"
  default     = null
}
variable "default_os_image" {
  description = "The OS image to use, if not given is vm[*].os_image."
  type        = string
  default     = "op-ovh-debian_12"
  nullable    = false

  validation {
    condition     = var.default_os_image != ""
    error_message = "Default OS image should not be empty."
  }
}

variable "vms" {
  type = map(object({
    secgroup_ids = optional(list(string), [])
    os_image     = string
    os_flavor    = string
  }))
  description = "VM(s) to deploy. map name => secgroup ids to apply."
  default     = {}
}

variable "ovh_region" {
  type = string
}
variable "project_user_username" {
  type = string
}
variable "project_user_password" {
  type = string
}
variable "project_id" {
  type = string
}

variable "public_key" {
  type        = string
  description = "Existing SSH public key to be able to connect to the vm(s)."
}
