data "azurerm_client_config" "current" {
}

# generate random password
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"

  keepers = {
    value = azurerm_resource_group.hubsite.name # generate once 
  }
}

resource "azurerm_resource_group" "hubsite" {
  name     = "hub-site-${var.location}"
  location = var.location
}