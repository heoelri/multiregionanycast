module "clientsite" {
  for_each = toset(var.clientsites)

  source = "./modules/clientsite"

  location = each.value
}

# foreach? multiple hubsites
# vpn connection from client site a to hubsite a
resource "azurerm_virtual_network_gateway_connection" "clientsite_to_hubsitea" {
  name                = "clientsite-to-hubsitea"
  location            = module.clientsite["westeurope"].location
  resource_group_name = module.clientsite["westeurope"].name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = module.clientsite["westeurope"].virtual_network_gateway_id
  peer_virtual_network_gateway_id = module.hubsite["westeurope"].virtual_network_gateway_id

  shared_key = random_password.vpn_shared_key.result
}

# vpn connection from hub site a to client site a
resource "azurerm_virtual_network_gateway_connection" "hubsitea_to_clientsite" {
  name                = "hubsitea-to-clientsite"
  location            = module.hubsite["westeurope"].location
  resource_group_name = module.hubsite["westeurope"].resource_group_name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = module.hubsite["westeurope"].virtual_network_gateway_id
  peer_virtual_network_gateway_id = module.clientsite["westeurope"].virtual_network_gateway_id

  shared_key = random_password.vpn_shared_key.result
}