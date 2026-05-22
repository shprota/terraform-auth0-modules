variable "name" {
  description = "Name of the SAML connection."
  type        = string
}

variable "display_name" {
  description = "Display name shown on the login button."
  type        = string
  default     = null
}

variable "metadata_url" {
  description = "IdP SAML metadata URL."
  type        = string
}

variable "sign_out_endpoint" {
  description = "SAML Single Logout URL from the IdP."
  type        = string
  default     = ""
}

variable "user_id_attribute" {
  description = "Attribute in the SAML token that maps to user_id. Empty string uses the NameID."
  type        = string
  default     = ""
}

variable "signature_algorithm" {
  description = "Algorithm used to sign the SAML assertion."
  type        = string
  default     = "rsa-sha256"
}

variable "digest_algorithm" {
  description = "Algorithm used to calculate the digest of the SAML assertion."
  type        = string
  default     = "sha256"
}

variable "sign_saml_request" {
  description = "Whether to sign the SAML authentication request."
  type        = bool
  default     = true
}

variable "fields_map" {
  description = "SAML attribute-to-Auth0 field mappings as a JSON string."
  type        = string
  default     = "{}"
}

variable "set_user_root_attributes" {
  description = "Determines when user root attributes are updated from the IdP. Use 'on_each_login' for JIT provisioning."
  type        = string
  default     = "on_each_login"
}

variable "enabled_clients" {
  description = "IDs of the clients for which the connection is enabled."
  type        = list(string)
  default     = []
}

variable "idp_initiated" {
  description = "IdP-initiated SSO settings. When enabled, Auth0 accepts unsolicited SAML responses from the IdP and starts a session for the given client."
  type = object({
    enabled                = bool
    client_id              = optional(string, "")
    client_protocol        = optional(string, "samlp")
    client_authorize_query = optional(string, "")
  })
  default = {
    enabled = false
  }
}
