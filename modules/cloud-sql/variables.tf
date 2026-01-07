variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "instance_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
}

variable "database_version" {
  description = "Database version (e.g., MARIADB_10_6, MARIADB_10_11)"
  type        = string
  default     = "MARIADB_10_6"
}

variable "tier" {
  description = "Machine tier (e.g., db-f1-micro, db-n1-standard-1)"
  type        = string
  default     = "db-f1-micro"
}

variable "vpc_network_id" {
  description = "VPC network self_link for private IP"
  type        = string
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
  default     = "app_database"
}

variable "db_password" {
  description = "Database password from Secret Manager"
  type        = string
  sensitive   = true
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}
