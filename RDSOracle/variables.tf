/**
    Providers variables
*/
variable "region" {
  description = "Region where the resources will be created"
  type        = string 
  default = "us-east-1"
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
  default = "us-east-1"
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
  description = "AWS Account name (i.e. RFS, MyGinnieMaeDev, DMC3-Test, CICD)"
  type        = string 
  default     = "Morpheus"
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
   type = "string"
   default = ""
}

variable "secret_cmk_id" {
  description = "The ID of the Customer Managed Key used to encrypt the Secret"
  type        = string
  default     = "b212caf4-3256-4e98-9851-ca49fdfb00c1"
}

variable "cicd_role_arn"{
  description = "The ARN of the CICD Role that will be given access to the Secret"
  type        = string
  default     = "arn:aws-us-gov:iam::678100103589:role/CICD_SOCSecretRetriever_Role"
}


/**
    Variables required to create the Security Group, IAM Role and Policy    
*/
/*
variable "vpc_id" {
  description = "The ID of the VPC where the RDS DB will be created"
  type        = string
 # default     = "vpc-0a4c258982b48c5f0"
}
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
  #default    = "10.50.0.0/20"
}

/***
    Variables required to create a parameter group
**/
variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "oracle-ee-19"
}


/***
    Variables required to create an options group
**/
variable "engine_name" {
  description = "Specifies the name of the engine that this option group should be associated with"
  type        = string
  default     = "oracle-ee"
}

variable "options" {
  description = "A list of Options to apply"
  type        = any
  default     = []
}
  
variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = "19"
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

/*
variable "db_username"{
  description = "Username, must be provided"
  type        = string 
}
*/


variable "db_port"{
  description = "The port on which the DB accepts connections"
  type        = string
  default     = "1521"
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
  default     = "19"
}

variable "character_set_name" {
  description = "(Optional) The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS for more information"
  type        = string
  default     = "WE8MSWIN1252"
}

variable "instance_class"{
  description = "Type of instance (i.e. db.m5.2xlarge)"
  type        = string 
  default     = "db.m5.xlarge"
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


variable "enable_s3_integration"{
  description = "Indicates if S3 integration should be turned on or not"
  type        = bool 
  default     = true
}

variable "open_cursors"{
  description = "Value for the parameter open_cursors"
  type        = number
  default     = 300
}

variable "undo_retention"{
  description = "Value for the parameter undo_retention"
  type        = number
  default     = 900
}

variable "query_rewrite_integrity"{
  description = "Value for the parameter query_rewrite_integrity"
  type        = string
  default     = "ENFORCED"
}

variable "enable_goldengate_replication"{
  description = "Value for the parameter enable_goldengate_replication"
  type        = bool 
  default     = false
}

variable "session_cached_cursors"{
  description = "Value for the parameter session_cached_cursors"
  type        = number
  default     = 50
}

variable "db_files"{
  description = "Value for the parameter db_files"
  type        = number
  default     = 200
}
