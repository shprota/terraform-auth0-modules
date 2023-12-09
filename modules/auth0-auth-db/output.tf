output "auth0-google-oauth-name" {
  value = data.auth0_connection.my-database-connection.name
}

output "auth0-connection_id" {
  value = data.auth0_connection.my-database-connection.id
}
