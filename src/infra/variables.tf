variable "clientsites" {
  description = "List of Azure regions used to deploy client sites."
  type        = list(string)
  default     = ["westeurope"]
}

variable "hubsites" {
  description = "List of Azure regions used to deploy hub sites."
  type        = list(string)
  default     = ["westeurope"]
}