locals {
  actions = { for v in var.actions : v.name => v }
  action_client_secrets = { for k, v in local.actions : k => {
    for i in try(v["client_secrets"], []) : i["name"] => module.auth0_client[i["client"]][i["output"]]
    }
  }
  action_secrets = { for k, v in local.actions : k => {
    for secret in try(v["secrets"], []) : secret["name"] => secret["value"]
    }
  }
}

module "action" {
  source   = "./modules/auth0-action"
  for_each = local.actions

  name               = each.value.name
  runtime            = try(each.value.runtime, "node18")
  code               = each.value.code
  supported_triggers = each.value.supported_triggers
  dependencies       = try(each.value.dependencies, [])
  deploy             = try(each.value.deploy, false)
  secrets            = merge(local.action_secrets[each.value.name], local.action_client_secrets[each.value.name])
}
