output "custom_data" { # cloud init output from router (quagga) vm
  value = "\n${data.template_file.cloudinit.rendered}"
}

output "location" {
    value = azurerm_resource_group.hubsite.location
}

output "resource_group_name" {
    value = azurerm_resource_group.hubsite.name
}

output "peer_virtual_network_gateway_id" {
    value = azurerm_virtual_network_gateway.hubsite_vpngw.id
}