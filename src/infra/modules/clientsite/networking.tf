resource "azurerm_resource_group" "clientsite" {
  name     = "client-site-westeurope"
  location = "westeurope"
}

# generate random password (used to access client vm)
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"

  keepers = {
    value = azurerm_resource_group.clientsite.name # generate once 
  }
}

# client side virtual network
resource "azurerm_virtual_network" "clientvneta" {
  name                = "${azurerm_resource_group.clientsite.name}-vnet"
  location            = azurerm_resource_group.clientsite.location
  resource_group_name = azurerm_resource_group.clientsite.name
  address_space       = ["10.10.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

# subnet used for client side vpn gateway (name must be set to GatewaySubnet)
resource "azurerm_subnet" "clientsite_gatewaysubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.clientsite.name
  virtual_network_name = azurerm_virtual_network.clientvneta.name
  address_prefixes     = ["10.10.1.0/24"]
}

# subnet used for azure bastion
resource "azurerm_subnet" "clientsite_subnet_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.clientsite.name
  virtual_network_name = azurerm_virtual_network.clientvneta.name
  address_prefixes     = ["10.10.2.0/24"]
}

# subnet used for client vm
resource "azurerm_subnet" "clientsite_subnet_clients" {
  name                 = "Subnet1"
  resource_group_name  = azurerm_resource_group.clientsite.name
  virtual_network_name = azurerm_virtual_network.clientvneta.name
  address_prefixes     = ["10.10.3.0/24"]
}