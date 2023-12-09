resource "auth0_client_grant" "my_client_grant" {
  depends_on = [module.auth0_client]
  for_each = { for k, v in var.client_grants : k => v }

  client_id = module.auth0_client[each.value.client_name].client_id
  audience  = each.value.audience
  scopes    = lookup(each.value, "scope", [])
}
