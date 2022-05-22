resource "azurerm_virtual_hub" "hubsite_vhub" {
  name                = "${azurerm_resource_group.hubsite.name}-vhub"
  resource_group_name = azurerm_resource_group.hubsite.name
  location            = azurerm_resource_group.hubsite.location
  sku                 = "Standard"
}

resource "azurerm_public_ip" "hubsite" {
  name                = "${azurerm_resource_group.hubsite.name}-pip"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_hub_ip" "hubsite_vhub_ip" {
  name                         = "${azurerm_resource_group.hubsite.name}-vhubipconfig"
  virtual_hub_id               = azurerm_virtual_hub.hubsite_vhub.id
  private_ip_address           = "10.1.5.18"
  private_ip_allocation_method = "Static"
  public_ip_address_id         = azurerm_public_ip.hubsite.id
  subnet_id                    = azurerm_subnet.hubvnet_subnet_routeserver.id
}

resource "azurerm_virtual_hub_bgp_connection" "hubsite_nva_connection" {
  name           = "${azurerm_resource_group.hubsite.name}-vhub-bgpconnection"
  virtual_hub_id = azurerm_virtual_hub.hubsite_vhub.id
  peer_asn       = var.peer_asn
  peer_ip        = azurerm_network_interface.hubsite_routervm_1.private_ip_address

  depends_on = [
    azurerm_virtual_hub_ip.hubsite_vhub_ip
  ]
}

