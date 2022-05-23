resource "azurerm_resource_group" "clientsitea" {
  name     = "client-site-westeurope"
  location = "westeurope"
}

# client side virtual network
resource "azurerm_virtual_network" "clientvneta" {
  name                = "${azurerm_resource_group.clientsitea.name}-vnet"
  location            = azurerm_resource_group.clientsitea.location
  resource_group_name = azurerm_resource_group.clientsitea.name
  address_space       = ["10.10.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

# subnet used for client side vpn gateway (name must be set to GatewaySubnet)
resource "azurerm_subnet" "clientsitea_gatewaysubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.clientsitea.name
  virtual_network_name = azurerm_virtual_network.clientvneta.name
  address_prefixes     = ["10.10.1.0/24"]
}

# subnet used for azure bastion
resource "azurerm_subnet" "clientsitea_subnet_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.clientsitea.name
  virtual_network_name = azurerm_virtual_network.clientvneta.name
  address_prefixes     = ["10.10.2.0/24"]
}

# subnet used for client vm
resource "azurerm_subnet" "clientsitea_subnet_clients" {
  name                 = "Subnet1"
  resource_group_name  = azurerm_resource_group.clientsitea.name
  virtual_network_name = azurerm_virtual_network.clientvneta.name
  address_prefixes     = ["10.10.3.0/24"]
}