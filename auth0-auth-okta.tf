locals {
  okta_enabled_clients = { for k, conn in var.okta_connections : k => [for client in conn.enabled_clients : module.auth0_client[client].client_id] }

  okta_idp_initiated = {
    for k, conn in var.okta_connections : k => (
      conn.idp_initiated.enabled
      ? {
        enabled                = true
        client_id              = module.auth0_client[conn.idp_initiated.client].client_id
        client_protocol        = conn.idp_initiated.client_protocol
        client_authorize_query = conn.idp_initiated.client_authorize_query
      }
      : { enabled = false }
    )
  }
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
  idp_initiated            = local.okta_idp_initiated[each.key]
}
