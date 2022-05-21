#
# VM-based Router (NVA)
#
resource "azurerm_network_interface" "hubsitea_routervm_1" {
  name                = "${azurerm_resource_group.hubsitea.name}-vm-router-nic"
  location            = azurerm_resource_group.hubsitea.location
  resource_group_name = azurerm_resource_group.hubsitea.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hubvnet_subnet_3.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hubsitea_routervm_1.id
  }
}

resource "azurerm_public_ip" "hubsitea_routervm_1" {
  name                = "${azurerm_resource_group.hubsitea.name}-vm-router-pip"
  location            = azurerm_resource_group.hubsitea.location
  resource_group_name = azurerm_resource_group.hubsitea.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_linux_virtual_machine" "hubsitea_routervm_1" {
  name                = "${azurerm_resource_group.hubsitea.name}-vm-router"
  resource_group_name = azurerm_resource_group.hubsitea.name
  location            = azurerm_resource_group.hubsitea.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = random_password.password.result

  disable_password_authentication = false

  #custom_data = base64encode(data.local_file.cloudinit.content)
  custom_data = base64encode(data.template_file.cloudinit.rendered)
  network_interface_ids = [
    azurerm_network_interface.hubsitea_routervm_1.id,
  ]

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.hubsitea_routervm_1.primary_blob_endpoint
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Data template Bash bootstrapping file
#data "local_file" "cloudinit" {
#  filename = "${path.module}/quagga.conf"
#}

data "template_file" "cloudinit" {
  template = file("${path.module}/quagga.conf")
  vars = {
    asn_quagga      = azurerm_virtual_hub_bgp_connection.hubsitea_nva_connection.peer_asn,
    bgp_routerId    = azurerm_network_interface.hubsitea_routervm_1.private_ip_address,
    bgp_network1    = azurerm_subnet.hubvnet_subnet_1.address_prefixes[0],
    bgp_network2    = azurerm_subnet.hubvnet_subnet_2.address_prefixes[0],
    bgp_network3    = azurerm_subnet.hubvnet_subnet_3.address_prefixes[0],
    routeserver_IP1 = "1.2.3.4",
    routeserver_IP2 = "4.3.2.1"
  }
}

resource "azurerm_storage_account" "hubsitea_routervm_1" {
  name                     = "hubsiteadiagstor"
  resource_group_name      = azurerm_resource_group.hubsitea.name
  location                 = azurerm_resource_group.hubsitea.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

output "metadata" {
  value = "\n${data.template_file.cloudinit.rendered}"
}