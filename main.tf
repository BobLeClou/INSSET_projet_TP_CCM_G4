module "network" {
    source = "./modules/network"
    for_each = var.networks

    #Paramètres du réseau
    vpc_name = lookup(each.value, "vpc_name", null)
    vpc_description = lookup(each.value, "vpc_description", null)
    vpc_auto_create_subnetworks = lookup(each.value, "vpc_auto_create_subnetworks", false)

    #Paramètre du sous-réseau correspondant
    subnetwork_name = lookup(each.value, "subnetwork_name", null)
    subnetwork_ip_cidr_range = lookup(each.value, "subnetwork_ip_cidr_range", null)
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
