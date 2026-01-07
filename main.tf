/*
# Bucket GCS pour stocker l'état Terraform
resource "google_storage_bucket" "terraform_state" {
  name          = "${var.project_id}-tfstate"
  project       = var.project_id
  location      = var.region
  force_destroy = false

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true

  lifecycle {
    prevent_destroy = true
  }
}

# Bucket GCS générique pour l'application
resource "google_storage_bucket" "app_bucket" {
  name          = "${var.project_id}-app-data"
  project       = var.project_id
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}
*/