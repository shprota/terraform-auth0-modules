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
  }
}

resource "auth0_connection_clients" "okta_saml_clients_assoc" {
  connection_id   = auth0_connection.okta_saml.id
  enabled_clients = var.enabled_clients
}
