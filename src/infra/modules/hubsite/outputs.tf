output "custom_data" { # cloud init output from router (quagga) vm
  value = "\n${data.template_file.cloudinit.rendered}"
}

output "peer_virtual_network_gateway_id" {
    value = azurerm_virtual_network_gateway.hubsite_vpngw.id
}