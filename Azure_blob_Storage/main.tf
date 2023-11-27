terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=2.99.0"
    }
  }
}
 
# Configure the Locals

locals {
   storLargeFileShare = "<%=customOptions.storLargeFileShare%>" == "on" ? true : var.storLargeFileShare
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
 features {}
 
 subscription_id            = var.subscription_id
 tenant_id                  = var.tenant_id
 client_id                  = var.client_id
 client_secret              = var.client_secret
 skip_provider_registration = true
}
 
resource "azurerm_resource_group" "example" {
 name     = var.resgrp
 location = "centralus"
}
 
resource "azurerm_storage_account" "example" {
 name                             = var.storName
 resource_group_name              = azurerm_resource_group.example.name
 location                         = azurerm_resource_group.example.location
 account_tier                     = "Standard"
 account_replication_type         = "LRS"
 account_kind                     = "StorageV2"
 cross_tenant_replication_enabled = "false"
 large_file_share_enabled         = "true"
  
 blob_properties {
  versioning_enabled = false
 }
}
 
resource "azurerm_storage_container" "example" {
 name                  = "content"
 storage_account_name  = azurerm_storage_account.example.name
 container_access_type = "private"
}