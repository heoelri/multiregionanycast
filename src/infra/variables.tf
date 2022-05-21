variable "sites" {
  description = "List of Azure regions used to deploy hub sites."
  type        = list(string)
  default     = ["westeurope"]
}