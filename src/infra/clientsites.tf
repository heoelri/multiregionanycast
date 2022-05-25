module "clientsite_westeurope" {
  source   = "./modules/clientsite"
  location = "westeurope"
}

# generate random password
resource "random_password" "vpn_shared_key" {
  length           = 64
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"

  keepers = {
    value = module.clientsite_westeurope.virtual_network_gateway_id
  }
}

# vpn connection from client site a to hubsite westeurope
resource "azurerm_virtual_network_gateway_connection" "clientsite_to_hubsitea" {
  name                = "clientsite-to-hubsite-westeurope"
  location            = module.clientsite_westeurope.location
  resource_group_name = module.clientsite_westeurope.resource_group_name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = module.clientsite_westeurope.virtual_network_gateway_id
  peer_virtual_network_gateway_id = module.hubsite_westeurope.virtual_network_gateway_id

  shared_key = random_password.vpn_shared_key.result 
}

# vpn connection from client site a to hubsite northeurope
resource "azurerm_virtual_network_gateway_connection" "clientsite_to_hubsiteb" {
  name                = "clientsite-to-hubsite-swedencentral"
  location            = module.clientsite_westeurope.location
  resource_group_name = module.clientsite_westeurope.resource_group_name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = module.clientsite_westeurope.virtual_network_gateway_id
  peer_virtual_network_gateway_id = module.hubsite_swedencentral.virtual_network_gateway_id

  enable_bgp = true

  shared_key = random_password.vpn_shared_key.result
}