output "site_properties" {
  value = [for instance in module.hubsite : {
    custom_data = instance.custom_data
    peer_virtual_network_gateway_id = instance.peer_virtual_network_gateway_id
  }]
}