resource "azurerm_network_interface" "clientsite_clientvm" {
  name                = "${azurerm_resource_group.clientsitea.name}-clientvm-nic"
  location            = azurerm_resource_group.clientsitea.location
  resource_group_name = azurerm_resource_group.clientsitea.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.clientsitea_subnet_clients.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "clientsite_clientvm" {
  name                = "${azurerm_resource_group.clientsitea.name}-clientvm"
  resource_group_name = azurerm_resource_group.clientsitea.name
  location            = azurerm_resource_group.clientsitea.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.clientsite_clientvm.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}