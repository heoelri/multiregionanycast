resource "azurerm_virtual_network" "hubsite" {
  name                = "${azurerm_resource_group.hubsite.name}-vnet"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name
  address_space       = var.address_space
}

resource "azurerm_subnet" "hubvnet_subnet_1" {
  name                 = "subnet1" # first network advertised from quagga to the router server
  resource_group_name  = azurerm_resource_group.hubsite.name
  virtual_network_name = azurerm_virtual_network.hubsite.name
  address_prefixes     = var.subnet_1_address_space
}

resource "azurerm_network_security_group" "hubvnet_subnet_1_nsg" {
  name                = "${azurerm_virtual_network.hubsite.name}-${azurerm_subnet.hubvnet_subnet_1.name}-nsg"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name
}

resource "azurerm_subnet_network_security_group_association" "hubvnet_subnet_1_nsg" {
  subnet_id                 = azurerm_subnet.hubvnet_subnet_1.id
  network_security_group_id = azurerm_network_security_group.hubvnet_subnet_1_nsg.id
}

resource "azurerm_subnet" "hubvnet_subnet_2" {
  name                 = "subnet2" # second network advertised from quagga to the router server
  resource_group_name  = azurerm_resource_group.hubsite.name
  virtual_network_name = azurerm_virtual_network.hubsite.name
  address_prefixes     = var.subnet_2_address_space
}

resource "azurerm_network_security_group" "hubvnet_subnet_2_nsg" {
  name                = "${azurerm_virtual_network.hubsite.name}-${azurerm_subnet.hubvnet_subnet_2.name}-nsg"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name
}

resource "azurerm_subnet_network_security_group_association" "hubvnet_subnet_2_nsg" {
  subnet_id                 = azurerm_subnet.hubvnet_subnet_2.id
  network_security_group_id = azurerm_network_security_group.hubvnet_subnet_2_nsg.id
}

resource "azurerm_subnet" "hubvnet_subnet_3" {
  name                 = "subnet3" # second network advertised from quagga to the router server
  resource_group_name  = azurerm_resource_group.hubsite.name
  virtual_network_name = azurerm_virtual_network.hubsite.name
  address_prefixes     = var.subnet_3_address_space
}

resource "azurerm_network_security_group" "hubvnet_subnet_3_nsg" {
  name                = "${azurerm_virtual_network.hubsite.name}-${azurerm_subnet.hubvnet_subnet_3.name}-nsg"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name
}

resource "azurerm_subnet_network_security_group_association" "hubvnet_subnet_3_nsg" {
  subnet_id                 = azurerm_subnet.hubvnet_subnet_3.id
  network_security_group_id = azurerm_network_security_group.hubvnet_subnet_3_nsg.id
}

resource "azurerm_subnet" "hubvnet_subnet_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hubsite.name
  virtual_network_name = azurerm_virtual_network.hubsite.name
  address_prefixes     = var.gatewaysubnet_address_space
}

resource "azurerm_subnet" "hubvnet_subnet_routeserver" {
  name                 = "RouteServerSubnet"
  resource_group_name  = azurerm_resource_group.hubsite.name
  virtual_network_name = azurerm_virtual_network.hubsite.name
  address_prefixes     = var.routeserversubnet_address_space
}

resource "azurerm_subnet" "hubvnet_subnet_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hubsite.name
  virtual_network_name = azurerm_virtual_network.hubsite.name
  address_prefixes     = var.bastionsubnet_address_space
}

resource "azurerm_network_security_group" "hubvnet_bastion_nsg" {
  name                = "${azurerm_virtual_network.hubsite.name}-bastion-nsg"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name
}