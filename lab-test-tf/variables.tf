# Customer Morpheus input may be labelled "privcloud" in the UI, but the TF
# variable name in their repo is "cloud". This repro uses "cloud".

variable "clouds" {
  description = "Glue: cloud selector — must be zoneId-cloudName (e.g. 1-Demo)"
  type        = string
  default     = "26324-QA VMware"
}

variable "groups" {
  description = "Group selector — included so tfvars ERB pattern matches customer layout"
  type        = string
  default     = "deepti"
}
