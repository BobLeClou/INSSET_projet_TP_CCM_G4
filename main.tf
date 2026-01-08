# ====================================
module "network" {
  source   = "./modules/network"
  for_each = var.networks

  #Paramètres du réseau
  vpc_name                    = lookup(each.value, "vpc_name", null)
  vpc_description             = lookup(each.value, "vpc_description", null)
  vpc_auto_create_subnetworks = lookup(each.value, "vpc_auto_create_subnetworks", false)

  #Paramètre du sous-réseau correspondant
  subnetwork_name          = lookup(each.value, "subnetwork_name", null)
  subnetwork_ip_cidr_range = lookup(each.value, "subnetwork_ip_cidr_range", null)
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
  vpc_id        = lookup(each.value, "vpc_id")
  subnetwork_id = lookup(each.value, "subnetwork_id")

  # Métadonnées (scripts de démarrage, etc.)
  metadata = lookup(each.value, "metadata", {})

  # Compte de service
  service_account_email  = local.instance_sa_emails[each.key]
  service_account_scopes = lookup(each.value, "service_account_scopes", ["https://www.googleapis.com/auth/cloud-platform"])

  # Health check optionnel
  health_check_id = lookup(each.value, "health_check_id", null)

  named_ports  = lookup(each.value, "named_ports", [])
  network_tags = lookup(each.value, "network_tags", [])

  depends_on = [module.service_accounts, module.secret_manager]
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

locals {
  service_accounts_emails = {
    for k, m in module.service_accounts :
    k => m.service_account_email
  }

  # Mapping instance_key -> sa_key
  instance_to_sa = {
    backend  = "backend_sa"
    frontend = "frontend_sa"
    bastion  = "bastion_sa"
  }

  # Emails mappés pour les instances (lookup sûr avec fallback)
  instance_sa_emails = {
    for instance_key in keys(var.instance_groups) :
    instance_key => lookup(local.service_accounts_emails, lookup(local.instance_to_sa, instance_key, ""), null)
  }
}

module "secret_manager" {
  source = "./modules/secret-manager"

  project_id = var.project_id

  secrets = {
    db_user     = { secret_data = "app_user" }
    db_password = { secret_data = "SuperSecurePassword123!" }
    db_name     = { secret_data = "app_database" }
  }

  backend_service_account_email = local.service_accounts_emails["backend_sa"]
}

# Module Cloud SQL
module "cloud_sql" {
  source = "./modules/cloud-sql"

  project_id     = var.project_id
  region         = var.region
  instance_name  = "mysql-instance"
  vpc_network_id = module.network["cloudsql"].vpc_id
  tier           = var.tier

  db_password = "SuperSecurePassword123!"
}

# Module Backend
module "compute_backend" {
  source = "./modules/compute-backend"

  project_id = var.project_id
  region     = var.region
  zone       = var.zone
  subnet_id  = module.network["back"].subnetwork_id

  cloud_sql_connection_name = module.cloud_sql.connection_name
  cloud_sql_private_ip      = module.cloud_sql.private_ip_address
  secret_ids                = module.secret_manager.secret_ids

  service_account_email = local.service_accounts_emails["backend_sa"]
}

#Module Load Balancer
module "load_balancer" {
  source = "./modules/load-balancer"

  proxy_subnet_ip_cidr_range = var.proxy_subnet_ip_cidr_range
<<<<<<< HEAD
  proxy_subnet_network       = module.network["front"].vpc_id
  allow_proxy_target_tags    = var.allow_proxy_target_tags
  firewall_proxy_prority     = var.firewall_proxy_prority
  lb_backend_service_group   = module.instances_groups["frontend"].instance_group_self_link

  depends_on = [module.network, module.instances_groups]
=======
  proxy_subnet_network = module.network["front"].vpc_id
  allow_proxy_target_tags = var.network_tags
  firewall_proxy_prority = var.firewall_proxy_prority

>>>>>>> dfd3e95 (Ajout dans le main.tf du load balancer et variables associees)
}