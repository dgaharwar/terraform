# Configure the Microsoft Azure Provider
provider "azurerm" { 
features {}
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
    default = ""
    sensitive = false
}
variable tenant_id {
    type = string
    default = ""
    sensitive = false
}
variable client_id {
    type = string
    default = ""
    sensitive = true
}
variable client_secret {
    type = string
    default = ""
    sensitive = true
}
