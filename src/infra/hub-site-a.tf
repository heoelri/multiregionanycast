resource "azurerm_resource_group" "hubsitea" {
  name     = "hub-site-a"
  location = "West Europe"
}

resource "azurerm_virtual_network" "hubvneta" {
  name                = "${azurerm_resource_group.hubsitea.name}-vnet"
  location            = azurerm_resource_group.hubsitea.location
  resource_group_name = azurerm_resource_group.hubsitea.name
  address_space       = ["10.1.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "hubvnet_subnet_1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubsitea.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubsitea.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_3" {
  name                 = "subnet3"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubsitea.name
  address_prefixes     = ["10.1.3.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_routeserver" {
  name                 = "RouteServerSubnet"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubsitea.name
  address_prefixes     = ["10.1.4.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_routeserver" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubsitea.name
  address_prefixes     = ["10.1.5.0/24"]
}