# Customer Morpheus input may be labelled "privcloud" in the UI, but the TF
# variable name in their repo is "cloud". This repro uses "cloud".

variable "privcloud" {
  description = "Glue: cloud selector — must be zoneId-cloudName (e.g. 3-LabCloud)"
  type        = string
}

variable "privcloud" {
  description = "VM hostname — included so tfvars ERB pattern matches customer layout"
  type        = string
  default     = "lab-test"
}
