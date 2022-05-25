resource "azurerm_container_group" "workload" {
  name                = "${azurerm_resource_group.workload.name}-ci"
  location            = azurerm_resource_group.workload.location
  resource_group_name = azurerm_resource_group.workload.name
  ip_address_type     = "Private"
  #dns_name_label      = "aci-label" conflicts with network_profile_id
  os_type = "Linux"

  network_profile_id = azurerm_network_profile.workload_subnet_1.id

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }
}