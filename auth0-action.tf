locals {
  actions = { for v in var.actions : v.name => v }
  action_client_secrets = { for k, v in local.actions : k => {
    for i in v["client_secrets"] : i["name"] => module.auth0_client[i["client"]][i["output"]]
    }
  }
  action_secrets = { for k, v in local.actions : k => {
    for secret in v["secrets"] : secret["name"] => secret["value"]
    }
  }
}

module "action" {
  source   = "./modules/auth0-action"
  for_each = local.actions

  name               = each.value.name
  runtime            = each.value.runtime
  code               = each.value.code
  supported_triggers = each.value.supported_triggers
  dependencies       = each.value.dependencies
  deploy             = each.value.deploy
  secrets            = merge(local.action_secrets[each.value.name], local.action_client_secrets[each.value.name])
}
