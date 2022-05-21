data "azurerm_client_config" "current" {
}

# generate random password
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_resource_group" "hubsitea" {
  name     = "hub-site-${var.location}"
  location = var.location
}