#RANCHER
#########################################################################################################
variable "kubernetesVersion" {
  description = "Variable to set the cluster name"
  default     = "v1.27.12+rke2r1"
}

variable "rke2ClusterName" {
  description = "Variable to set the cluster name"
  default     = "terraform-caas-test-init"
}

variable "containerRegistry" {
  description = "Variable to set the container registry for the default registry and rke2 rewrite endpoint - DO NOT set any protocol (http/https), will be rewritten to https:// in the background"
  default     = "host46.testlab.local"
}

variable "proxy" {
  description = "Proxy for communication with Rancher, Harbor & Vault which are deployed in MAOAM"
  default     = "10.32.20.36:3128"
}

variable "no_proxy" {
  default     = "127.0.0.0/8,10.43.0.0/16,172.16.0.0/12,192.168.0.0/16,10.23.0.0/16,.svc,.cluster.local,host46.testlab.local"
  description = "NO_PROXY rules to make sure proxy is only used for communication with Rancher, Harbor & Vault"
}

#Morpheus
#########################################################################################################
variable "access_key" {}
variable "secret_key" {}



#vSPHERE
#########################################################################################################
# variable "datacenterName" {
#   type        = string
#   description = "The name of the vSphere Datacenter into which resources will be created."
#   default     = "HZD"
# }

# variable "vSphereClusterName" {
#   type        = string
#   description = "The vSphere Cluster into which resources will be created."
#   default     = "Demo"
# }

# variable "datastoreName" {
#   type        = string
#   description = "The vSphere Datastore into which resources will be created."
#   default     = "ESXi-dc2-esxif-01-LUN01"
# }

# # variable "datastoreClusterName" {
# #   type    = string
# #   default = "ESXi-DC2-DEMO"
# # }

# variable "vmNetworkName" {
#   type    = string
#   default = "VLAN0002 - Internal Server 2"
# }

# variable "templateName" {
#   type    = string
#   default = "/HZD/vm/Cloud-templates/caas-rhel9-2"
# }

# variable "folder" {
#   type    = string
#   default = "/"
# }


# variable "hostnameMaster" {
#   description = "Naming of the Master Nodes (will be added with cluster name and number)"
#   default     = "master"
# }

# variable "hostnameWorker" {
#   description = "Naming of the Master Nodes (will be added with cluster name and number)"
#   default     = "worker"
# }

# variable "masterCount" {
#   description = "How many Masternodes?"
#   type        = number
#   default     = 1
# }

# variable "workerCount" {
#   description = "How many Workernodes?"
#   type        = number
#   default     = 1
# }


#CLOUD-INIT
#########################################################################################################
# variable "ipv4" {
#   description = "Node IPv4 address"
#   default     = "10.23.21.220"
# }

# variable "gwv4" {
#   description = "Node IPv4 gateway"
#   default     = "10.23.21.1"
# }

# variable "dns1" {
#   description = "Node nameserver primary"
#   default     = "10.23.21.8"
# }

# variable "dns2" {
#   description = "Node nameserver secondary"
#   default     = "10.23.21.9"
# }
