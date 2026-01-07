variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
}

variable "instance_name" {
  description = "Name of the backend instance"
  type        = string
  default     = "backend-instance"
}

variable "machine_type" {
  description = "Machine type for the instance"
  type        = string
  default     = "e2-micro"
}

variable "subnet_id" {
  description = "Subnet ID for the backend instance"
  type        = string
}

variable "cloud_sql_connection_name" {
  description = "Cloud SQL connection name"
  type        = string
}

variable "cloud_sql_private_ip" {
  description = "Cloud SQL private IP address"
  type        = string
}

variable "secret_ids" {
  description = "Map of secret IDs from Secret Manager"
  type        = map(string)
}

variable "boot_disk_image" {
  description = "Boot disk image"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "service_account_email" {
  description = "Service account email for the backend"
  type        = string
}