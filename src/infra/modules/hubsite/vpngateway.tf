resource "azurerm_public_ip" "hubsite_vpngw_pip1" {
  name                = "${azurerm_resource_group.hubsite.name}-vpngw-pip"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name

  allocation_method = "Dynamic"
}

resource "azurerm_public_ip" "hubsite_vpngw_pip2" {
  name                = "${azurerm_resource_group.hubsite.name}-vpngw-pip"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "hubsite_vpngw" {
  name                = "${azurerm_resource_group.hubsite.name}-vpngw"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = true
  enable_bgp    = true
  sku           = "HighPerformance"

  ip_configuration {
    name                          = "vnetGatewayConfig1"
    public_ip_address_id          = azurerm_public_ip.hubsite_vpngw_pip1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hubvnet_subnet_gateway.id
  }

  ip_configuration {
    name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.hubsite_vpngw_pip2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hubvnet_subnet_gateway.id
  }
}