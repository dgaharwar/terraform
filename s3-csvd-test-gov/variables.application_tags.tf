# include this link to bring in the variable
# include the link to the .tfvars to bring in the values

variable "application_tags" {
  description = "Default application tags to be used on non-infrastructure resources"
  type        = map(string)
  default     = {}
}
