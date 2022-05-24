# generate random password (used to access client vm)
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"

  keepers = {
    value = azurerm_resource_group.clientsite.name # generate once 
  }
}

resource "azurerm_network_interface" "clientsite_clientvm" {
  name                = "${azurerm_resource_group.clientsite.name}-clientvm-nic"
  location            = azurerm_resource_group.clientsite.location
  resource_group_name = azurerm_resource_group.clientsite.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.clientsite_subnet_clients.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "clientsite_clientvm" {
  name                = "${substr(azurerm_resource_group.clientsite.name,0,10)}-vm"
  resource_group_name = azurerm_resource_group.clientsite.name
  location            = azurerm_resource_group.clientsite.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = random_password.password.result
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