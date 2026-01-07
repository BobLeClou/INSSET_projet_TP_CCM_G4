# ====================================
# BUCKETS GCS
# ====================================

# Bucket GCS pour stocker l'état Terraform
# Ce bucket hébergera le fichier tfstate après le premier apply
resource "google_storage_bucket" "terraform_state" {
    name          = "${var.project_id}-tfstate"
    project       = var.project_id
    location      = var.region
    force_destroy = false

    # Active le versioning pour garder l'historique des états
    versioning {
        enabled = true
    }
    # Protection contre la suppression accidentelle
    lifecycle {
        prevent_destroy = true
    }
}


# ====================================
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

# ====================================
# MODULE INSTANCES - VIA MAP ET FOR_EACH
# ====================================
# On délègue le réseau à une autre équipe.
# Ici, on utilise des placeholders explicites "A CHANGER-..."
# et on instancie le module instances pour chaque entrée de var.instance_groups.

module "instances_groups" {
    source   = "./modules/instances"
    for_each = var.instance_groups

    # Identification du groupe
    instance_group_name = lookup(each.value, "instance_group_name", "${var.project_id}-${each.key}-group")
    base_instance_name  = lookup(each.value, "base_instance_name", each.key)

    # Localisation
    zone = lookup(each.value, "zone", var.zone)

    # Configuration des instances
    target_size  = lookup(each.value, "target_size", 1)
    machine_type = lookup(each.value, "machine_type", "e2-micro")
    source_image = lookup(each.value, "source_image", "os_image")

    # Configuration réseau (placeholders si non fournis)
    vpc_id        = lookup(each.value, "vpc_id", "A CHANGER-network-self-link")
    subnetwork_id = lookup(each.value, "subnetwork_id", "A CHANGER-${each.key}-subnet-self-link")

    # Métadonnées (scripts de démarrage, etc.)
    metadata = lookup(each.value, "metadata", {})

    # Compte de service
    service_account_email  = lookup(each.value, "service_account_email", ["A CHANGER-service-account-email-GENERIQUE"])
    service_account_scopes = lookup(each.value, "service_account_scopes", ["cloud-platform"])

    # Health check optionnel
    health_check_id = lookup(each.value, "health_check_id", null)
}

# ====================================
# MODULE SA-IAM - VIA MAP ET FOR_EACH
# ====================================
# Crée des comptes de service et applique les rôles projet associés.

module "service_accounts" {
    source   = "./modules/SA-IAM"
    for_each = var.service_accounts

    project_id         = var.project_id
    service_account_id = lookup(each.value, "account_id", each.key)
    display_name       = lookup(each.value, "display_name", null)
    description        = lookup(each.value, "description", null)
    roles              = lookup(each.value, "roles", [])
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
    instance_name   = "mysql-instance"
    vpc_network_id  = module.network["cloudsql"].vpc_id
    
    db_password     = "SuperSecurePassword123!"
}

# Module Backend
module "compute_backend" {
    source = "./modules/compute-backend"
    
    project_id                = var.project_id
    region                    = var.region
    zone                      = var.zone
    subnet_id                 = module.network["back"].subnetwork_id
    
    cloud_sql_connection_name = module.cloud_sql.connection_name
    cloud_sql_private_ip      = module.cloud_sql.private_ip_address
    secret_ids                = module.secret_manager.secret_ids
    
    service_account_email     = google_service_account.backend_sa.email
}
