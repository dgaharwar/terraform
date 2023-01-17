# Segments variables
variable "morpheus_url" {
  description = "The URL of the Morpheus platform"
  type        = string
}

variable "access_token" {
  description = "The access token of the user account used to access the Morpheus platform"
  type        = string
}

variable "tf_client_name" {
  default = "<%= customOptions.clientName %>"
}
