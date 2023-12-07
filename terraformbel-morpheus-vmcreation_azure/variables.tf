variable "morpheus_url" {
  type = string

  description = "URL of morpheus instance"
}

variable "morpheus_token" {
  type        = string
  description = "auth token"
}

variable "azure_group" {
  type        = string
  description = "Name of the azure group in Morpheus"
}
