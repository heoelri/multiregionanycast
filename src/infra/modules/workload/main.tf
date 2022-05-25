data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "workload" {
  name     = "workload-${var.location}"
  location = var.location

  tags = {
    "Project" = "anycast"
  }
}