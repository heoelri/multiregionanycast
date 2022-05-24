# public ip address used for client side vpn gateway
resource "azurerm_public_ip" "clientsite_pip" {
  name                = "${azurerm_resource_group.clientsite.name}-vpn-pip"
  location            = azurerm_resource_group.clientsite.location
  resource_group_name = azurerm_resource_group.clientsite.name

  allocation_method = "Dynamic"
}

# client side vpn gateway
resource "azurerm_virtual_network_gateway" "clientsite" {
  name                = "${azurerm_resource_group.clientsite.name}-vpngw"
  location            = azurerm_resource_group.clientsite.location
  resource_group_name = azurerm_resource_group.clientsite.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "Standard"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.clientsite_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.clientsite_gatewaysubnet.id
  }
}