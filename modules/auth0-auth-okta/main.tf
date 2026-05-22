resource "auth0_connection" "okta_saml" {
  name                 = var.name
  display_name         = var.display_name != null ? var.display_name : var.name
  strategy             = "samlp"
  show_as_button       = true

  options {
    metadata_url             = var.metadata_url
    sign_out_endpoint        = var.sign_out_endpoint
    user_id_attribute        = var.user_id_attribute != "" ? var.user_id_attribute : null
    signature_algorithm      = var.signature_algorithm
    digest_algorithm         = var.digest_algorithm
    sign_saml_request        = var.sign_saml_request
    set_user_root_attributes = var.set_user_root_attributes
    fields_map               = var.fields_map

    dynamic "idp_initiated" {
      for_each = var.idp_initiated.enabled ? [var.idp_initiated] : []
      content {
        enabled                = true
        client_id              = idp_initiated.value.client_id
        client_protocol        = idp_initiated.value.client_protocol
        client_authorize_query = idp_initiated.value.client_authorize_query
      }
    }
  }
}

resource "auth0_connection_clients" "okta_saml_clients_assoc" {
  connection_id   = auth0_connection.okta_saml.id
  enabled_clients = var.enabled_clients
}
