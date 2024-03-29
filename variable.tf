variable "vnet_name" {
description = "Name of the vnet to create"
default = "dg-vNet"
}

variable "resource_group_name" {
description = "Default resource group name that the network will be created in."
default = "dg-ops"
}

variable "location" {
description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "address_space" {
description = "The address space that is used by the virtual network."
default = "10.0.0.0/16"
}

# If no values specified, this defaults to Azure DNS
variable "dns_servers" {
description = "The DNS servers to be used with vNet."
default = []
}

variable "subnet_prefixes" {
description = "The address prefix to use for the subnet."
default = ["10.0.0.0/24"]
}

variable "subnet_names" {
description = "A list of public subnets inside the vNet."
default = ["dgmorphsubnet"]
}

variable "tags" {
description = "The tags to associate with your network and subnets."
type = "map"
default = {
tag1 = ""
tag2 = ""
}
}

variable "allow_rdp_traffic" {
description = "This optional variable, when set to true, adds a security rule allowing RDP traffic to flow through to the newly created network. The default $
default = false
}

variable "allow_ssh_traffic" {
description = "This optional variable, when set to true, adds a security rule allowing SSH traffic to flow through to the newly created network. The default $
default = false
}


variable "sg_name" {
description = "Give a name to security group"
default = "dg-nsg"
}