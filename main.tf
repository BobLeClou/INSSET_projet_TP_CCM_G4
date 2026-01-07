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

# Service Account créé en premier (avant les modules)
resource "google_service_account" "backend_sa" {
  project      = var.project_id
  account_id   = "backend-service-account"
  display_name = "Backend Service Account"
}

# IAM roles pour le Service Account Backend
resource "google_project_iam_member" "backend_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.backend_sa.email}"
}

resource "google_project_iam_member" "backend_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.backend_sa.email}"
}

# Module Secret Manager
module "secret_manager" {
  source = "./modules/secret-manager"
  
  project_id = var.project_id
  
  secrets = {
    db_user     = { secret_data = "app_user" }
    db_password = { secret_data = "SuperSecurePassword123!" }
    db_name     = { secret_data = "app_database" }
  }
  
  backend_service_account_email = google_service_account.backend_sa.email
}

# Module Cloud SQL
module "cloud_sql" {
  source = "./modules/cloud-sql"
  
  project_id      = var.project_id
  region          = var.region
  instance_name   = "mariadb-instance"
  vpc_network_id  = module.network.vpc_id
  
  db_password     = "SuperSecurePassword123!"
}

# Module Backend
module "compute_backend" {
  source = "./modules/compute-backend"
  
  project_id                = var.project_id
  region                    = var.region
  zone                      = var.zone
  subnet_id                 = module.network.backend_subnet_id
  
  cloud_sql_connection_name = module.cloud_sql.connection_name
  cloud_sql_private_ip      = module.cloud_sql.private_ip_address
  secret_ids                = module.secret_manager.secret_ids
  
  service_account_email     = google_service_account.backend_sa.email
}
