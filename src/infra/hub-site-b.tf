resource "azurerm_resource_group" "hubsiteb" {
  name     = "hub-site-b"
  location = "North Europe"
}

resource "azurerm_virtual_network" "hubvnetb" {
  name                = "${azurerm_resource_group.hubsiteb.name}-vnet"
  location            = azurerm_resource_group.hubsiteb.location
  resource_group_name = azurerm_resource_group.hubsiteb.name
  address_space       = ["10.2.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]
}