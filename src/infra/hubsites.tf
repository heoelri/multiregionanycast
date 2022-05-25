module "hubsite_westeurope" {
  source   = "./modules/hubsite"
  location = "westeurope" 

  vpn_asn = 65100 # vpn gateway bgp asn
  peer_asn = 65110 # route server bgp asn

  address_space = ["10.100.0.0/16"]

  subnet_1_address_space = ["10.100.1.0/24"]
  subnet_2_address_space = ["10.100.2.0/24"]
  subnet_3_address_space = ["10.100.3.0/24"]

  gatewaysubnet_address_space     = ["10.100.4.0/24"]
  routeserversubnet_address_space = ["10.100.5.0/24"]
  bastionsubnet_address_space     = ["10.100.6.0/24"]

  routeserver_ip1 = "10.100.5.4" # needs to be set manually (based on routeserversubnet)
  routeserver_ip2 = "10.100.5.5" # needs to be set manually (based on routeserversubnet)
}

module "hubsite_swedencentral" {
  source   = "./modules/hubsite"
  location = "swedencentral" 

  vpn_asn = 65200 # vpn gateway bgp asn
  peer_asn = 65210 # route server bgp asn

  address_space = ["10.200.0.0/16"]

  subnet_1_address_space = ["10.200.1.0/24"]
  subnet_2_address_space = ["10.200.2.0/24"]
  subnet_3_address_space = ["10.200.3.0/24"]

  gatewaysubnet_address_space     = ["10.200.4.0/24"]
  routeserversubnet_address_space = ["10.200.5.0/24"]
  bastionsubnet_address_space     = ["10.200.6.0/24"]

  routeserver_ip1 = "10.200.5.4" # needs to be set manually (based on routeserversubnet)
  routeserver_ip2 = "10.200.5.5" # needs to be set manually (based on routeserversubnet)
}