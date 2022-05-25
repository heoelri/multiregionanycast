module "hubsite_westeurope" {
  source   = "./modules/hubsite"
  location = "westeurope"

  asn_vpngw  = 64512 # vpn gateway bgp asn
  asn_routeserver = 64513 # route server bgp asn (ignored always 65515)
  asn_routernva = 64514 # router nva bgp asn

  address_space = ["10.100.0.0/16"] # address space used for hubsite virtual network

  subnet_1_address_space = ["10.100.1.0/24"]
  subnet_2_address_space = ["10.100.2.0/24"]
  subnet_3_address_space = ["10.100.3.0/24"]

  gatewaysubnet_address_space     = ["10.100.4.0/24"] # vpn gateway subnet
  routeserversubnet_address_space = ["10.100.5.0/24"] # azure route server subnet
  bastionsubnet_address_space     = ["10.100.6.0/24"] # azure bastion subnet
}

module "hubsite_swedencentral" {
  source   = "./modules/hubsite"
  location = "swedencentral"

  asn_vpngw  = 65521 # vpn gateway bgp asn
  asn_routeserver = 65522 # route server bgp asn (ignored always 65515)
  asn_routernva = 65523 # router nva bgp asn

  address_space = ["10.200.0.0/16"] # address space used for hubsite virtual network

  subnet_1_address_space = ["10.200.1.0/24"]
  subnet_2_address_space = ["10.200.2.0/24"]
  subnet_3_address_space = ["10.200.3.0/24"]

  gatewaysubnet_address_space     = ["10.200.4.0/24"] # vpn gateway subnet
  routeserversubnet_address_space = ["10.200.5.0/24"] # azure route server subnet
  bastionsubnet_address_space     = ["10.200.6.0/24"] # azure bastion subnet
}