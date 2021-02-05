variable "soc_region" {
  description = "Region for the SOC account (to create the Secret)"
  type        = string 
  default = "us-gov-west-1"
}

variable "soc_access_key"{
  description = "Access Key for the SOC account (to create the Secret)"
  type        = string 
}

variable "soc_secret_key" {
  description = "Secret Key for the SOC account (to create the Secret)"
  type        = string 
}

variable "secret_arn"{
   description = "The ARN of an existing secret, if the values should be updated. Leave blank if a new Secret needs to be created"
   type        = string
   default     = ""
}

variable "secret_name" { 
  description = "Leave blank. The system will automatically popuplate this field."
  type        = string
  default     = "N/A"
}

variable "secret_cmk_id" {
  default = "b212caf4-3256-4e98-9851-ca49fdfb00c1"
}

variable "cicd_role_arn"{
  default = "arn:aws-us-gov:iam::678100103589:role/CICD_SOCSecretRetriever_Role"
}

variable "secret_value_dbname" {
    type = "string"
    default = "placeholder"
}

variable "secret_value_dbendpoint" {
    type    = string
    default = "placeholder"
}

variable "secret_value_dbarn" {
    type    = string
    default = "placeholder"
}

variable "secret_value_dbusername" {
    type    = string
    default = "placeholder"
}

variable "secret_value_dbpassword" {
    type    = string
    default = "placeholder"
}

variable "db_port" {
    type    = string
    default = "placeholder"
}

variable "account_name" {
    type    = string
    default = "placeholder"
}

variable "engine_name" {
    type    = string
    default = "placeholder"
}
