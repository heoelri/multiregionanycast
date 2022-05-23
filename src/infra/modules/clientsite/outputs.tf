output "virtual_network_gateway_id" {
    value = azurerm_virtual_network_gateway.clientsite_vpngw.id
}

output "location" {
    value = azurerm_resource_group.clientsite.location
}

output "resource_group_name" {
    value = azurerm_resource_group.clientsite.name
}