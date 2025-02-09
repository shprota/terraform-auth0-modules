
resource "auth0_user" "user" {
  for_each = { for user in var.users : user.email => user }

  connection_name = var.connection_name
  name            = each.value.name
  email           = each.value.email
  password        = each.value.password
  email_verified  = true
  nickname        = each.value.name
}

resource "auth0_user_roles" "user_roles" {
  for_each = { for user in var.users : user.email => user }
  user_id  = auth0_user.user[each.key].id
  roles    = each.value.roles
}
