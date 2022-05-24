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
}

# peer remote virtual network with workload vnet
resource "azurerm_virtual_network_peering" "peering-to" {
  name                      = "peer-remote-vnet-with-workload"
  resource_group_name       = var.hubsite_resource_group_name
  virtual_network_name      = var.peer_with_vnet_id
  remote_virtual_network_id = azurerm_virtual_network.workload.id
}

# peer workload vnet with remote virtual network
resource "azurerm_virtual_network_peering" "peering-from" {
  name                      = "peer-workload-with-remote-vnet"
  resource_group_name       = azurerm_resource_group.workload.name
  virtual_network_name      = azurerm_virtual_network.workload.name
  remote_virtual_network_id = var.peer_with_vnet_id
}