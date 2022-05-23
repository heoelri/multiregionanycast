output "hubsite_properties" {
  value = [for instance in module.hubsite : {
    custom_data                = instance.custom_data
    virtual_network_gateway_id = instance.virtual_network_gateway_id
  }]
}