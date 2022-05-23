resource "azurerm_public_ip" "hubsite_bastion_pip" {
  name                = "${azurerm_resource_group.hubsite.name}-bastion-pip"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "hubsite_bastion" {
  name                = "${azurerm_resource_group.hubsite.name}-bastion"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hubvnet_subnet_bastion.id
    public_ip_address_id = azurerm_public_ip.hubsite_bastion_pip.id
  }
}