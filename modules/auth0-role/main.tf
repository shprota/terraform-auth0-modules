resource "auth0_role" "roles" {
  for_each = { for role in var.roles : role.name => role.description }

  name        = each.key
  description = each.value
}

resource "auth0_role_permissions" "permissions" {
  for_each = length(var.permissions) >= 1 ? { for role in var.roles : role.name => role.description } : {}
  role_id  = auth0_role.roles[each.key].id

  dynamic "permissions" {
    for_each = var.permissions
    content {
      name                       = permissions.value.name
      resource_server_identifier = permissions.value.resource_server_identifier
    }
  }
}
