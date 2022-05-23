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

# foreach? multiple hubsites
# vpn connection from client site a to hubsite a
resource "azurerm_virtual_network_gateway_connection" "clientsite_to_hubsitea" {
  name                = "clientsite-to-hubsite"
  location            = module.clientsite["westeurope"].location
  resource_group_name = module.clientsite["westeurope"].resource_group_name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = module.clientsite["westeurope"].virtual_network_gateway_id
  peer_virtual_network_gateway_id = module.hubsite["westeurope"].virtual_network_gateway_id

  shared_key = random_password.vpn_shared_key.result
}

# vpn connection from hub site a to client site a
resource "azurerm_virtual_network_gateway_connection" "hubsitea_to_clientsite" {
  name                = "hubsite-to-clientsite"
  location            = module.hubsite["westeurope"].location
  resource_group_name = module.hubsite["westeurope"].resource_group_name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = module.hubsite["westeurope"].virtual_network_gateway_id
  peer_virtual_network_gateway_id = module.clientsite["westeurope"].virtual_network_gateway_id

  shared_key = random_password.vpn_shared_key.result
}