variable "location" {
  description = "Azure Region used for this hub site deployment."
  type        = string
}

variable "peer_asn" {
  description = "Autonomous system number assigned to quagga router vm"
  default = 65001
}