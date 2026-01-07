output "instance_name" {
  description = "Name of the Cloud SQL instance"
  value       = google_sql_database_instance.mariadb.name
}

output "connection_name" {
  description = "Connection name for Cloud SQL Proxy"
  value       = google_sql_database_instance.mariadb.connection_name
}

output "private_ip_address" {
  description = "Private IP address of the Cloud SQL instance"
  value       = google_sql_database_instance.mariadb.private_ip_address
}

output "database_name" {
  description = "Name of the created database"
  value       = google_sql_database.database.name
}

output "self_link" {
  description = "Self link of the Cloud SQL instance"
  value       = google_sql_database_instance.mariadb.self_link
}
