resource "azurerm_virtual_network" "workload" {
  name                = "${azurerm_resource_group.workload.name}-vnet"
  location            = azurerm_resource_group.workload.location
  resource_group_name = azurerm_resource_group.workload.name
  address_space       = var.address_space
}

resource "azurerm_subnet" "workload_subnet_1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.workload.name
  virtual_network_name = azurerm_virtual_network.workload.name
  address_prefixes     = var.subnet_1_address_space

  delegation {
    name = "Microsoft.ContainerInstance.containerGroups"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_network_security_group" "workload_subnet_1" {
  name                = "${azurerm_virtual_network.workload.name}-${azurerm_subnet.workload_subnet_1.name}-nsg"
  location            = azurerm_resource_group.workload.location
  resource_group_name = azurerm_resource_group.workload.name
}

resource "azurerm_subnet_network_security_group_association" "workload_subnet_1_nsg" {
  subnet_id                 = azurerm_subnet.workload_subnet_1.id
  network_security_group_id = azurerm_network_security_group.workload_subnet_1.id
}

resource "azurerm_network_profile" "workload_subnet_1" {
  name                = "networkprofile"
  location            = azurerm_resource_group.workload.location
  resource_group_name = azurerm_resource_group.workload.name

  container_network_interface {
    name = "containernic"

    ip_configuration {
      name      = "ipconfig"
      subnet_id = azurerm_subnet.workload_subnet_1.id
    }
  }
}

# peer remote virtual network with workload vnet
resource "azurerm_virtual_network_peering" "peering-to" {
  name                      = "peer-hubsite-vnet-with-workload"
  resource_group_name       = var.hubsite_resource_group_name # hubsite virtual network resource group
  virtual_network_name      = var.hubsite_virtual_network_name # hubsite virtual network name

  remote_virtual_network_id = azurerm_virtual_network.workload.id # workload virtual network resource id
}

# peer workload vnet with remote virtual network
resource "azurerm_virtual_network_peering" "peering-from" {
  name                      = "peer-workload-with-hubsite"
  resource_group_name       = azurerm_resource_group.workload.name # workload virtual network resource group
  virtual_network_name      = azurerm_virtual_network.workload.name # workload virtual network name

  remote_virtual_network_id = var.peer_with_vnet_id # hubsite virtual network resource id
}