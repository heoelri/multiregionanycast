#
# VM-based Router (NVA)
#
resource "azurerm_network_interface" "hubsite_routervm_1" {
  name                = "${azurerm_resource_group.hubsite.name}-vm-router-nic"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hubvnet_subnet_3.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "hubsite_routervm_1" {
  name                = "${azurerm_resource_group.hubsite.name}-vm-router"
  resource_group_name = azurerm_resource_group.hubsite.name
  location            = azurerm_resource_group.hubsite.location
  size                = "Standard_F2"
  admin_username      = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = trimspace(tls_private_key.routernv_private_key.public_key_openssh) #file("~/.ssh/id_rsa.pub")
  }

  #admin_password      = random_password.password.result
  #disable_password_authentication = false
  #custom_data = base64encode(data.local_file.cloudinit.content)

  custom_data = base64encode(data.template_file.cloudinit.rendered)
  network_interface_ids = [
    azurerm_network_interface.hubsite_routervm_1.id,
  ]

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.hubsite_routervm_1.primary_blob_endpoint
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
    asn_quagga      = azurerm_virtual_hub_bgp_connection.hubsite_nva_connection.peer_asn, # Autonomous system number assigned to quagga
    bgp_routerId    = azurerm_network_interface.hubsite_routervm_1.private_ip_address, # IP address of quagga VM
    bgp_network1    = azurerm_subnet.hubvnet_subnet_1.address_prefixes[0], # first network advertised from quagga to the router server (inclusive of subnetmask)
    bgp_network2    = azurerm_subnet.hubvnet_subnet_2.address_prefixes[0], # second network advertised from quagga to the router server (inclusive of subnetmask)
    bgp_network3    = azurerm_subnet.hubvnet_subnet_3.address_prefixes[0], # third network advertised from quagga to the router server (inclusive of subnetmask)
    routeserver_IP1 = "1.2.3.4", # first IP address of the router server 
    routeserver_IP2 = "4.3.2.1" # second IP address of the router server
  }
}

resource "azurerm_storage_account" "hubsite_routervm_1" {
  name                     = "hubsitediagstor"
  resource_group_name      = azurerm_resource_group.hubsite.name
  location                 = azurerm_resource_group.hubsite.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}