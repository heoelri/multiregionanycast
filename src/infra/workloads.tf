module "workload_westeurope" {
  source   = "./modules/workload"
  location = "westeurope"

  # address space used for the workload
  address_space          = ["192.168.0.0/16"]
  subnet_1_address_space = ["192.168.1.0/24"]

  # azure resource id of the hubsite vnet to peer with
  peer_with_vnet_id            = module.hubsite_westeurope.virtual_network_id
  hubsite_resource_group_name  = module.hubsite_westeurope.resource_group_name
  hubsite_virtual_network_name = module.hubsite_westeurope.virtual_network_name
}

module "workload_swedencentral" {
  source   = "./modules/workload"
  location = "swedencentral"

  # address space used for the workload
  address_space          = ["192.168.0.0/16"]
  subnet_1_address_space = ["192.168.1.0/24"]

  # azure resource id of the hubsite vnet to peer with
  peer_with_vnet_id            = module.hubsite_swedencentral.virtual_network_id
  hubsite_resource_group_name  = module.hubsite_swedencentral.resource_group_name
  hubsite_virtual_network_name = module.hubsite_swedencentral.virtual_network_name
}