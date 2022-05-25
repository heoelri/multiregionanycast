# resource "azurerm_virtual_hub" "hubsite_vhub" {
#   name                = "${azurerm_resource_group.hubsite.name}-routeserver"
#   resource_group_name = azurerm_resource_group.hubsite.name
#   location            = azurerm_resource_group.hubsite.location
#   sku                 = "Standard"
# }

# public ip used for azure route server (required)
resource "azurerm_public_ip" "hubsite_routeserver" {
  name                = "${azurerm_resource_group.hubsite.name}-routeserver-pip"
  location            = azurerm_resource_group.hubsite.location
  resource_group_name = azurerm_resource_group.hubsite.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# deploy azure route server via azapi (due to a lack of functionality in azurerm)
resource "azapi_resource" "hubsite_routeserver" {
  type      = "Microsoft.Network/virtualHubs@2020-11-01"
  name      = "${azurerm_resource_group.hubsite.name}-routeserver"
  parent_id = azurerm_resource_group.hubsite.id
  location  = azurerm_resource_group.hubsite.location

  body = jsonencode({
    properties = {
      sku                        = "Standard"
      allowBranchToBranchTraffic = true,
      virtualRouterAsn           = "${var.peer_asn}"
    }
  })

  response_export_values = [
    "properties.virtualRouterIps"
  ]
}

output "virtualRouterIP1" {
  value = jsondecode(azapi_resource.hubsite_routeserver.output).properties.virtualRouterIps[0]
}
output "virtualRouterIP2" {
  value = jsondecode(azapi_resource.hubsite_routeserver.output).properties.virtualRouterIps[1]
}

# azure route server resource
resource "azurerm_virtual_hub_ip" "hubsite_vhub_ip" {
  name = "${azurerm_resource_group.hubsite.name}-vhubipconfig"

  virtual_hub_id = azapi_resource.hubsite_routeserver.id

  #virtual_hub_id = azurerm_virtual_hub.hubsite_vhub.id
  #private_ip_address           = "10.1.5.18"
  private_ip_allocation_method = "Dynamic" #"Static"
  public_ip_address_id         = azurerm_public_ip.hubsite_routeserver.id
  subnet_id                    = azurerm_subnet.hubvnet_subnet_routeserver.id
}

# bgp connection for azure route server
resource "azurerm_virtual_hub_bgp_connection" "hubsite_nva_connection" {
  name = "${azurerm_resource_group.hubsite.name}-vhub-bgpconnection"
  #virtual_hub_id = azurerm_virtual_hub.hubsite_vhub.id
  virtual_hub_id = azapi_resource.hubsite_routeserver.id
  peer_asn       = var.peer_asn # bgp asn for azure route server
  peer_ip        = azurerm_network_interface.hubsite_routervm_1.private_ip_address

  depends_on = [
    azurerm_virtual_hub_ip.hubsite_vhub_ip
  ]
}

