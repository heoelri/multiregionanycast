output "site_properties" {
  value = [for instance in module.hubsite : {
    location    = instance.location
    custom_data = instance.custom_data
  }]
}