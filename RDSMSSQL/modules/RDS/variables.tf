/**
    Provider variables
*/
variable "region" {
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


/**
    Generic variables
*/
variable "client"{
  description = "Name of the client"
  type        = string 
  default     = "Deloitte / Ginnie Mae"
}

variable "environment"{
  description = "Environment."
  type        = string 
  default     = ""
}


/**
    Variables required to create the Security Group, IAM Role and Policy    
*/
variable "vpc_subnet_az1"{
  description = "ID of the VPC subnet in the 1st Availability Zone"
  type        = string
}

variable "vpc_subnet_az2"{
  description = "ID of the VPC subnet in the 2nd Availability Zone"
  type        = string  
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

