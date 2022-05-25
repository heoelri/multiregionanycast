output "hubsite_westeurope_cloudinit" {
  value = module.hubsite_westeurope.custom_data
}

output "hubsite_westeurope_virtualRouterIP1" {
  value = module.hubsite_westeurope.virtualRouterIP1
}

output "hubsite_westeurope_virtualRouterIP2" {
  value = module.hubsite_westeurope.virtualRouterIP2
}

output "hubsite_swedencentral_cloudinit" {
  value = module.hubsite_swedencentral.custom_data
}

output "hubsite_swedencentral_virtualRouterIP1" {
  value = module.hubsite_swedencentral.virtualRouterIP1
}

output "hubsite_swedencentral_virtualRouterIP2" {
  value = module.hubsite_swedencentral.virtualRouterIP2
}