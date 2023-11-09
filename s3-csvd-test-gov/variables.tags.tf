# this exists in CAT, but not in other accounts.  At some point, remove this file and all references to
# var.tags

variable "tags" {
  description = "AWS Tags to apply to appropriate resources."
  type        = map(string)
  default     = {}
}

