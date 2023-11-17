terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = ">=2.99.0"
      }
    }
}

provider "azurerm" {
  features {}

  subscription_id  = var.subscription_id
  tenant_id        = var.tenant_id
  client_id        = var.client_id
  client_secret    = var.client_secret
}

locals {
  os_image_config = {
    "win10-22h2-pro-g2" = {
      publisher = "MicrosoftWindowsDesktop"
      offer     = "windows-10"
      sku       = "win10-22h2-pro-g2"
      version   = "latest"
    }
    "windows2022dc" = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-Datacenter"
      version   = "latest"
    }
    windows2019dc = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
    
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = format("%s-vnet", var.vm_name )
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = format("%s-subnet", var.vm_name )
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = format("%s-id", var.vm_name )
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  name                = format("%s-nic", var.vm_name )
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = format("%s-nsg", var.vm_name )
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowRDP"
    description                = "Allow RDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*" 
  }

  security_rule {
    name                       = "AllowHTTPS"
    description                = "Allow HTTPS"
    priority                   = 301
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"  
  }

    security_rule {
    name                       = "AllowWinRM"
    description                = "Allow WinRM"
    priority                   = 302
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"  
  }

  security_rule {
    name                       = "AllowHTTP"
    description                = "Allow HTTP"
    priority                   = 302
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_interface_security_group_association" "attach_Nic_Nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching                       = var.windowsvm_caching
    storage_account_type          = var.disk_type
  }

  source_image_reference {
    publisher = local.os_image_config[var.os_image]["publisher"]
    offer     = local.os_image_config[var.os_image]["offer"]
    sku       = local.os_image_config[var.os_image]["sku"]
    version   = local.os_image_config[var.os_image]["version"]
  }
}