variable "location" {
  description = "Azure Region used for this hub site deployment."
  type        = string
}

variable "asn_routernva" {
  description = "Autonomous system number assigned to quagga router vm"
  default     = 65001
}

variable "asn_vpngw" {
  description = "Autonomous system number used by the VPN GW"
  default     = 65515
}

variable "asn_routeserver" {
  description = "Autonomous system number used by the VPN GW"
  default     = 65515
}

variable "address_space" {
  description = "Hubsite Virtual Network Address Space"
  default     = ["10.1.0.0/16"]
}

variable "subnet_1_address_space" {
  description = "Hubsite Virtual Network Address Space"
  default     = ["10.1.1.0/24"]
}

variable "subnet_2_address_space" {
  description = "Hubsite Virtual Network Address Space"
  default     = ["10.1.2.0/24"]
}

variable "subnet_3_address_space" {
  description = "Hubsite Virtual Network Address Space"
  default     = ["10.1.3.0/24"]
}

variable "gatewaysubnet_address_space" {
  description = "Hubsite Virtual Network Address Space"
  default     = ["10.1.4.0/24"]
}

variable "routeserversubnet_address_space" {
  description = "Hubsite Virtual Network Address Space"
  default     = ["10.1.5.0/24"]
}

variable "bastionsubnet_address_space" {
  description = "Hubsite Virtual Network Address Space"
  default     = ["10.1.6.0/24"]
}