locals {
  okta_enabled_clients = [for clients in var.okta_connections : flatten([for client in clients.enabled_clients : [module.auth0_client[client].client_id]])]
}

module "auth0-auth-okta" {
  source   = "./modules/auth0-auth-okta"
  for_each = { for k, v in var.okta_connections : k => v }

  name                     = each.value.name
  display_name             = each.value.display_name
  metadata_url             = each.value.metadata_url
  sign_out_endpoint        = each.value.sign_out_endpoint
  user_id_attribute        = each.value.user_id_attribute
  fields_map               = each.value.fields_map
  set_user_root_attributes = each.value.set_user_root_attributes
  enabled_clients          = local.okta_enabled_clients[each.key]
}
