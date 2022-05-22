resource "azurerm_public_ip" "hubsite_vpngw_pip" {
  name                = "${azurerm_resource_group.hubsite.name}-vpngw-pip"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "example" {
  name                = "${azurerm_resource_group.hubsite.name}-vpngw"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.hubsite_vpngw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hubvnet_subnet_gateway.id
  }
}