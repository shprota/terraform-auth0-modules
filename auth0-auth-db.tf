locals {
  db_enabled_clients = [for clients in var.db_connections : flatten([for client in clients.enabled_clients : [module.auth0_client[client].client_id]])]
}

module "auth0-auth-db" {
  source   = "./modules/auth0-auth-db"
  for_each = { for k, v in var.db_connections : k => v }

  name                           = each.value.name
  custom_scripts                 = each.value.custom_scripts
  password_policy                = each.value.password_policy
  password_history               = each.value.password_history
  password_no_personal_info      = each.value.password_no_personal_info
  password_dictionary            = each.value.password_dictionary
  brute_force_protection         = each.value.brute_force_protection
  enabled_database_customization = each.value.enabled_database_customization
  custom_scripts_configuration   = each.value.custom_scripts_configuration
  enabled_clients                = local.db_enabled_clients[each.key]
}
