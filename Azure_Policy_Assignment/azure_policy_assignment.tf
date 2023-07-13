# Configure the Microsoft Azure Provider
provider "azurerm" { 
features {}
#   use ENV VARS
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
    client_id       = var.client_id
    client_secret   = var.client_secret
        # whilst the `version` attribute is optional, we recommend pinning toa given version of the Provider
    version = "=2.5.0"
}

# Configire the data
data "azurerm_resource_group" "example" {
    name     = "rmg-ops"
}

# Configire the resources
resource "azurerm_policy_assignment" "example" {
    name                 = "View and configure system diagnostic data"
    scope                = data.azurerm_resource_group.example.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0015ea4d-51ff-4ce3-8d8c-f3f8f0179a56"
}


# Configire the Variables
variable subscription_id {
    type = string
    default = "3b6ff759-299c-4a48-bef8-d1e612b57658"
    sensitive = false
}
variable tenant_id {
    type = string
    default = "b16e2942-acf7-4664-a827-c99d7e81a77d"
    sensitive = false
}
variable client_id {
    type = string
    default = "ea0042dd-7aa4-48b0-a018-05b5f0aa14f1"
    sensitive = true
}
variable client_secret {
    type = string
    default = "2.28Q~R7Y9nS7ViLHWhDZoGghwoWPZcluAfrFaD6"
    sensitive = true
}