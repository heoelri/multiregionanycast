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
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_3" {
  name                 = "subnet3"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.3.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_routeserver" {
  name                 = "RouteServerSubnet"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.4.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.5.0/24"]
}

resource "azurerm_virtual_hub" "hubsitea_vhub" {
  name                = "${azurerm_resource_group.hubsitea.name}-vhub"
  resource_group_name = azurerm_resource_group.hubsitea.name
  location            = azurerm_resource_group.hubsitea.location
  sku                 = "Standard"
}

resource "azurerm_public_ip" "hubsitea" {
  name                = "${azurerm_resource_group.hubsitea.name}-pip"
  location            = azurerm_resource_group.hubsitea.location
  resource_group_name = azurerm_resource_group.hubsitea.name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_hub_ip" "hubsitea_vhub_ip" {
  name                         = "${azurerm_resource_group.hubsitea.name}-vhubipconfig"
  virtual_hub_id               = azurerm_virtual_hub.hubsitea_vhub.id
  private_ip_address           = "10.5.1.18"
  private_ip_allocation_method = "Static"
  public_ip_address_id         = azurerm_public_ip.hubsitea.id
  subnet_id                    = azurerm_subnet.hubvnet_subnet_routeserver.id
}