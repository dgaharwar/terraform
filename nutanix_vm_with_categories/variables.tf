# ------------------------------
# Variables
# ------------------------------
variable "nutanix_username" { type = string }
variable "nutanix_password" {
  type = string
  sensitive = true
}
variable "nutanix_endpoint" { type = string }
variable "cluster_uuid" { type = string }
variable "image_uuid"   { type = string }
variable "subnet_uuid"  { type = string }
variable "vm_name"      {
  type = string
  default = "tf-demo-vm"
}

# Categories as Morpheus would send them
variable "categories_dataset" {
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    { name = "Department:Support", value = "Department:Support" },
    { name = "Application:Morpheus", value = "Application:Morpheus" },
    { name = "Owner:Deepti", value = "Owner:Deepti" }
  ]
}