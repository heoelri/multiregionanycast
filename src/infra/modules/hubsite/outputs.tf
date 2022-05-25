output "custom_data" { # cloud init output from router (quagga) vm
  value = "\n${data.template_file.cloudinit.rendered}"
}

# returns the hubsite's location
output "location" {
  value = azurerm_resource_group.hubsite.location
}

# returns the hubsite's resource group name
output "resource_group_name" {
  value = azurerm_resource_group.hubsite.name
}

# returns the azure resource id of the hubsite's vpn gateway
output "virtual_network_gateway_id" {
  value = azurerm_vpn_gateway.hubsite_vpngw.id
}

# returns the azure resource id of the hubsite's virtual network
output "virtual_network_id" {
  value = azurerm_virtual_network.hubsite.id
}

# returns the name of the hubsite's virtual network
output "virtual_network_name" {
  value = azurerm_virtual_network.hubsite.name
}