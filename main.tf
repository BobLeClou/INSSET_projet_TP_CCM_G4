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

  uniform_bucket_level_access = true

  # Protection contre la suppression accidentelle
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
