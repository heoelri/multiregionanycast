# public ip address used for client side vpn gateway
resource "azurerm_public_ip" "clientsite_vpngw_pip" {
  name                = "${azurerm_resource_group.clientsite.name}-vpn-pip"
  location            = azurerm_resource_group.clientsite.location
  resource_group_name = azurerm_resource_group.clientsite.name

  allocation_method = "Dynamic"
}

# client side vpn gateway
resource "azurerm_virtual_network_gateway" "clientsite_vpngw" {
  name                = "${azurerm_resource_group.clientsite.name}-vpngw"
  location            = azurerm_resource_group.clientsite.location
  resource_group_name = azurerm_resource_group.clientsite.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.clientsite_vpngw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.clientsite_gatewaysubnet.id
  }
}

# generate random password
resource "random_password" "vpn_shared_key" {
  length           = 64
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"

  keepers = {
    value = azurerm_virtual_network_gateway.clientsite_vpngw.id
  }
}

# foreach? multiple hubsites
# vpn connection from client site a to hubsite a
resource "azurerm_virtual_network_gateway_connection" "clientsite_to_hubsitea" {
  name                = "clientsite-to-hubsitea"
  location            = azurerm_resource_group.clientsite.location
  resource_group_name = azurerm_resource_group.clientsite.name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.clientsite_vpngw.id
  peer_virtual_network_gateway_id = module.hubsite["westeurope"].peer_virtual_network_gateway_id

  shared_key = random_password.vpn_shared_key.result
}

# vpn connection from hub site a to client site a
resource "azurerm_virtual_network_gateway_connection" "hubsitea_to_clientsite" {
  name                = "hubsitea-to-clientsite"
  location            = module.hubsite["westeurope"].location
  resource_group_name = module.hubsite["westeurope"].resource_group_name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = module.hubsite["westeurope"].peer_virtual_network_gateway_id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.clientsite_vpngw.id

  shared_key = random_password.vpn_shared_key.result
}