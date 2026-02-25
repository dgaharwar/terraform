variable "project_id" {
  type        = string
  description = "ID of the project to share network with."
}

variable "description" {
  type        = string
  description = "Description of the user."
  default     = "User created by Infrastructure as code tool to create resources in a dedicated project."
}

variable "roles" {
  type = list(string)
  default = [
    "network_operator",
    "network_security_operator",
    "compute_operator",
    "image_operator",
  ]
}
