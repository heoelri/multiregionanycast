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
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_hub_ip" "hubsitea_vhub_ip" {
  name                         = "${azurerm_resource_group.hubsitea.name}-vhubipconfig"
  virtual_hub_id               = azurerm_virtual_hub.hubsitea_vhub.id
  private_ip_address           = "10.1.5.18"
  private_ip_allocation_method = "Static"
  public_ip_address_id         = azurerm_public_ip.hubsitea.id
  subnet_id                    = azurerm_subnet.hubvnet_subnet_routeserver.id
}

resource "azurerm_virtual_hub_bgp_connection" "hubsitea_nva_connection" {
  name           = "${azurerm_resource_group.hubsitea.name}-vhub-bgpconnection"
  virtual_hub_id = azurerm_virtual_hub.hubsitea_vhub.id
  peer_asn       = 65001
  peer_ip        = azurerm_network_interface.hubsitea_routervm_1.private_ip_address

  depends_on = [
    azurerm_virtual_hub_ip.hubsitea_vhub_ip
  ]
}

