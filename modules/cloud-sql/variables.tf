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
  description = "Database version (e.g., MYSQL_8_0, MYSQL_8_4)"
  type        = string
  default     = "MYSQL_8_0"
}

variable "tier" {
  description = "Machine tier (e.g., db-f1-medium, db-n1-standard-1)"
  type        = string
  default     = "db-f1-medium"
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
