resource "azurerm_resource_group" "clientsitea" {
  name     = "client-site-westeurope"
  location = "westeurope"
}

resource "azurerm_virtual_network" "clientvneta" {
  name                = "${azurerm_resource_group.clientsitea.name}-vnet"
  location            = azurerm_resource_group.clientsitea.location
  resource_group_name = azurerm_resource_group.clientsitea.name
  address_space       = ["10.10.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "clientsitea_gatewaysubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.clientsitea.name
  virtual_network_name = azurerm_virtual_network.clientvneta.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_public_ip" "clientsitea_vpngw_pip" {
  name                = "${azurerm_resource_group.clientsitea.name}-vpn-pip"
  location            = azurerm_resource_group.clientsitea.location
  resource_group_name = azurerm_resource_group.clientsitea.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "clientsitea_vpngw" {
  name                = "${azurerm_resource_group.clientsitea.name}-vpngw"
  location            = azurerm_resource_group.clientsitea.location
  resource_group_name = azurerm_resource_group.clientsitea.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.clientsitea_vpngw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.clientsitea_gatewaysubnet.id
  }
}

# generate random password
resource "random_password" "vpn_shared_key" {
  length           = 64
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# foreach? multiple hubsites
resource "azurerm_virtual_network_gateway_connection" "clientsitea_to_hubsitea" {
  name                = "clientsitea-to-hubsitea"
  location            = azurerm_resource_group.clientsitea.location
  resource_group_name = azurerm_resource_group.clientsitea.name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.clientsitea_vpngw.id
  peer_virtual_network_gateway_id = module.hubsite["westeurope"].peer_virtual_network_gateway_id

  shared_key = random_password.vpn_shared_key.result
}

resource "azurerm_virtual_network_gateway_connection" "hubsitea_to_clientsitea" {
  name                = "clientsitea-to-hubsitea"
  location            = module.hubsite["westeurope"].location
  resource_group_name = module.hubsite["westeurope"].resource_group_name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = module.hubsite["westeurope"].peer_virtual_network_gateway_id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.clientsitea_vpngw.id

  shared_key = random_password.vpn_shared_key.result
}