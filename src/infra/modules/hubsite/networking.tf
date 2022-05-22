resource "azurerm_virtual_network" "hubvneta" {
  name                = "${azurerm_resource_group.hubsite.name}-vnet"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name
  address_space       = ["10.1.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "hubvnet_subnet_1" {
  name                 = "subnet1" # first network advertised from quagga to the router server
  resource_group_name  = azurerm_resource_group.hubsite.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_2" {
  name                 = "subnet2" # second network advertised from quagga to the router server
  resource_group_name  = azurerm_resource_group.hubsite.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_3" {
  name                 = "subnet3" # second network advertised from quagga to the router server
  resource_group_name  = azurerm_resource_group.hubsite.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.3.0/24"]
}

resource "azurerm_network_security_group" "hubvnet_subnet_3_nsg" {
  name                = "${azurerm_virtual_network.hubvneta.name}-${azurerm_subnet.hubvnet_subnet_3.name}-nsg"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name

  security_rule {                              # temporary allow SSH in - should be disabled or locked down later
    name                       = "SSH-inbound" # allow inbound for router nva vm
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22" # ssh
    source_address_prefix      = "*"
    destination_address_prefix = "*" # azurerm_network_interface.hubsite_routervm_1.private_ip_address
  }
}

resource "azurerm_subnet_network_security_group_association" "hubvnet_subnet_3_nsg" {
  subnet_id                 = azurerm_subnet.hubvnet_subnet_3.id
  network_security_group_id = azurerm_network_security_group.hubvnet_subnet_3_nsg.id
}

resource "azurerm_subnet" "hubvnet_subnet_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hubsite.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.4.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_routeserver" {
  name                 = "RouteServerSubnet"
  resource_group_name  = azurerm_resource_group.hubsite.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.5.0/24"]
}