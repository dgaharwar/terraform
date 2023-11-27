variable "storName" {
 type    = string
 default = "test"
}
 
#variable "storLargeFileShare" {
#  type    = bool
#  default = false
#}
 
variable subscription_id {
 type = string
}

variable tenant_id {
 type = string
}
 
variable client_id {
 type = string
}
 
variable client_secret {
 type = string
}
 
variable resgrp {
 type    = string
 default = "rmg-ops"
}