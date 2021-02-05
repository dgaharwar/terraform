/**
    Providers variables
*/
variable "region" {
  description = "Region where the resources will be created"
  type        = string 
  default = "us-gov-west-1"
}

variable "access_key"{
  description = "Access Key"
  type        = string 
}

variable "secret_key" {
  description = "Secret Key"
  type        = string 
}

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

/**
    Generic variables
*/
variable "client"{
  description = "Name of the client"
  type        = string 
  default     = "GinnieMae"
}

variable "account_name" { 
  default = "RFS" 
}

variable "environment"{
  description = "Environment"
  type        = string 
  default     = ""
}

/***
    Variables required to create a secret
**/
variable "secret_arn"{
   description = "The ARN of an existing secret, if the values should be updated. Leave blank if a new Secret needs to be created"
   type = string
   default = ""
}

variable "cicd_role_arn"{
  description = "The ARN of the CICD Role that will be given access to the Secret"
  type        = string
  default     = "arn:aws-us-gov:iam::678100103589:role/CICD_SOCSecretRetriever_Role"
}

/**
    Variables required to create the Security Group, IAM Role and Policy    
*/
variable "vpc_subnet_az1"{
  description = "ID of the VPC subnet in the 1st Availability Zone"
  type        = string
  #default     = "subnet-0c6b68ad1b5731ff8"
}

variable "vpc_subnet_az2"{
  description = "ID of the VPC subnet in the 2nd Availability Zone"
  type        = string  
  #default     = "subnet-01677bc21cc8f2c15"
}

variable "workspaces_cidr"{
  description = "CIDR block of the Workspaces subnet"
  type        = string  
  default    = "10.50.0.0/20"
}

/***
    Variables required to create a parameter group
**/
variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "sqlserver-ee-15.0"
}

/***
    Variables required to create an options group
**/
variable "engine_name" {
  description = "Specifies the name of the engine that this option group should be associated with"
  type        = string
  default     = "sqlserver-ee"
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = "15.00"
}

/***
    Variables required to create a subnet group
**/


/***
    Variables required to create an instance
**/

variable "db_name"{
  description = "Name of the new database, must be provided"
  type        = string 
}

variable "db_port"{
  description = "The port on which the DB accepts connections"
  type        = string
  default     = "1433"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number #string?
  default     = 500
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 1000
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "15.00.4043.16.v1"
}

variable "character_set_name" {
  description = "(Optional) The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS for more information"
  type        = string
  default     = ""
}

variable "instance_class"{
  description = "Type of instance"
  type        = string 
  default     = "db.m5.4xlarge" #"db.t3.small" #"db.m5.xlarge" 
}

variable "storage_type"{
  description = "Type of storage"
  type        = string 
  default     = "io1"
}

#     Instance backup & maintenance options
variable "backup_window" {
  description = "Backup window (times)"
  type        = string
  default     = "20:00-21:00"
}

variable "backup_retention_period" {
  description = "Number of days to keep a backup"
  type        = number
  default     = 35
}

variable "maintenance_window" {
  description = "Day(s) when maintenance will take place"
  type        = string
  default     = "Fri:22:00-Fri:23:00"
}
