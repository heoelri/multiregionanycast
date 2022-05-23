module "clientsite" {
  for_each = toset(var.clientsites)

  source = "./modules/clientsite"

  location = each.value
}

# generate random password
resource "random_password" "vpn_shared_key" {
  length           = 64
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"

  keepers = {
    value = module.clientsite["westeurope"].virtual_network_gateway_id
  }
}

# vpn connection from client site a to hubsite a
resource "azurerm_virtual_network_gateway_connection" "clientsite_to_hubsitea" {
  name                = "clientsite-to-hubsite-westeurope"
  location            = module.clientsite["westeurope"].location
  resource_group_name = module.clientsite["westeurope"].resource_group_name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = module.clientsite["westeurope"].virtual_network_gateway_id
  peer_virtual_network_gateway_id = module.hubsite["westeurope"].virtual_network_gateway_id

  shared_key = random_password.vpn_shared_key.result
}

# vpn connection from client site a to hubsite a
resource "azurerm_virtual_network_gateway_connection" "clientsite_to_hubsiteb" {
  name                = "clientsite-to-hubsite-northeurope"
  location            = module.clientsite["westeurope"].location
  resource_group_name = module.clientsite["westeurope"].resource_group_name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = module.clientsite["northeurope"].virtual_network_gateway_id
  peer_virtual_network_gateway_id = module.hubsite["northeurope"].virtual_network_gateway_id

  shared_key = random_password.vpn_shared_key.result
}