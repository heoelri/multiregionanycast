data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "clientsite" {
  name     = "client-site-${var.location}"
  location = var.location

  tags = {
    "Project" = "anycast"
  }
}