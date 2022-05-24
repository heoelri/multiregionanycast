variable "location" {
  description = "Azure Region used for this hub site deployment."
  type        = string
}

variable "address_space" {
  description = "Workload Virtual Network Address Space"
  default = ["192.168.0.0/16"]
}

variable "subnet_1_address_space" {
  description = "Workload Subnet 1 Address Space"
  default = ["192.168.1.0/24"]
}

variable "peer_with_vnet_id" {
  description = "Resource ID of the target virtual network"
}