module "hubsite" {
  for_each = toset(var.hubsites)

  source = "./modules/hubsite"

  location = each.value
  # asn
  # address range
  # subnet 1 address range
  # subnet 2 address range
  # subnet 3 address range
}