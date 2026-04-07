resource "auth0_trigger_actions" "this" {
  for_each = var.trigger_bindings

  trigger = each.key

  dynamic "actions" {
    for_each = each.value
    content {
      id           = module.action[actions.value].id
      display_name = module.action[actions.value].display_name
    }
  }
}
