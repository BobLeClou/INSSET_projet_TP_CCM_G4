variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "secrets" {
  description = "Map of secrets to create (db_user, db_password, db_name)"
  type = map(object({
    secret_data = string
  }))
}

variable "backend_service_account_email" {
  description = "Service account email for backend to access secrets"
  type        = string
}