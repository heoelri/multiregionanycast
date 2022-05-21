variable "sites" {
  description = "List of Azure regions into which stamps are deployed. Important: The main location (var.location) MUST be included as the first item in this list."
  type        = list(string)
  default     = ["westeurope"]
}