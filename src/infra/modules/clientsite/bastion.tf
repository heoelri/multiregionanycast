resource "azurerm_public_ip" "clientsite_bastion_pip" {
  name                = "${azurerm_resource_group.clientsite.name}-bastion-pip"
  location            = azurerm_resource_group.clientsite.location
  resource_group_name = azurerm_resource_group.clientsite.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "clientsite_bastion" {
  name                = "${azurerm_resource_group.clientsite.name}-bastion"
  location            = azurerm_resource_group.clientsite.location
  resource_group_name = azurerm_resource_group.clientsite.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.clientsite_subnet_bastion.id
    public_ip_address_id = azurerm_public_ip.clientsite_bastion_pip.id
  }
}