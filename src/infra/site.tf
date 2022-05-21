module "hubsite" {
  for_each = toset(var.sites)

  source = "./modules/hubsite"

  location = each.value
}