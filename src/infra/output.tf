output "site_properties" {
  value = [for instance in module.hubsite : {
    custom_data = instance.custom_data
  }]
}