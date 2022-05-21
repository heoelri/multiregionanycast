resource "azurerm_key_vault" "hubsitea" {
  name                        = "${azurerm_resource_group.hubsitea.name}-kv"
  location                    = azurerm_resource_group.hubsitea.location
  resource_group_name         = azurerm_resource_group.hubsitea.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}

# Give KV secret permissions to the service principal that runs the Terraform apply itself
resource "azurerm_key_vault_access_policy" "devops_pipeline" {
  key_vault_id = azurerm_key_vault.hubsitea.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Delete", "Purge", "Set", "Backup", "Restore", "Recover"
  ]
}

resource "azurerm_key_vault_secret" "nva_admin_password" {
  name         = "nva-admin-password"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.hubsitea.id
}