data "auth0_connection" "google_oauth2" {
  name                 = "google-oauth2"
}

resource "auth0_connection_clients" "google_clients_assoc" {
  connection_id   = data.auth0_connection.google_oauth2.id
  enabled_clients = var.enabled_clients
}