resource "azurerm_resource_group" "hubsitea" {
  name     = "hub-site-a"
  location = "West Europe"
}

resource "azurerm_virtual_network" "hubvneta" {
  name                = "${azurerm_resource_group.hubsitea.name}-vnet"
  location            = azurerm_resource_group.hubsitea.location
  resource_group_name = azurerm_resource_group.hubsitea.name
  address_space       = ["10.1.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "hubvnet_subnet_1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_3" {
  name                 = "subnet3"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.3.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.4.0/24"]
}

resource "azurerm_subnet" "hubvnet_subnet_routeserver" {
  name                 = "RouteServerSubnet"
  resource_group_name  = azurerm_resource_group.hubsitea.name
  virtual_network_name = azurerm_virtual_network.hubvneta.name
  address_prefixes     = ["10.1.5.0/24"]
}

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
  }
}

resource "azurerm_linux_virtual_machine" "hubsitea_routervm_1" {
  name                = "${azurerm_resource_group.hubsitea.name}-vm-router"
  resource_group_name = azurerm_resource_group.hubsitea.name
  location            = azurerm_resource_group.hubsitea.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = random_password.password.result

  disable_password_authentication = false

  custom_data = base64encode(data.local_file.cloudinit.content)

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
data "local_file" "cloudinit" {
  #filename = "${path.module}/quagga.conf"
  filename = templatefile(
      "${path.module}/quagga.conf", {
          asn_quagga = azurerm_virtual_hub_bgp_connection.hubsitea_nva_connection.peer_asn,
          bgp_routerId = azurerm_network_interface.hubsitea_routervm_1.private_ip_address
      }
  )
}

resource "azurerm_storage_account" "hubsitea_routervm_1" {
  name                     = "hubsiteadiagstor"
  resource_group_name      = azurerm_resource_group.hubsitea.name
  location                 = azurerm_resource_group.hubsitea.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}