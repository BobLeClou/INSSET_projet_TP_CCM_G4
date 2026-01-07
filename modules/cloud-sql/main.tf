# Cloud SQL Instance MariaDB avec Private IP
resource "google_sql_database_instance" "mariadb" {
  name             = var.instance_name
  project          = var.project_id
  region           = var.region
  database_version = var.database_version

  deletion_protection = var.deletion_protection

  settings {
    tier              = var.tier
    availability_type = "ZONAL"
    disk_type         = "PD_SSD"
    disk_size         = 10

    # Configuration réseau privé
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_network_id
      require_ssl     = false
    }

    # Configuration des backups automatiques
    backup_configuration {
      enabled            = true
      start_time         = "02:00"
      binary_log_enabled = true
      
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }

    # Maintenance window
    maintenance_window {
      day          = 7  # Dimanche
      hour         = 3
      update_track = "stable"
    }
  }
}

# Création de la base de données
resource "google_sql_database" "database" {
  name     = var.database_name
  project  = var.project_id
  instance = google_sql_database_instance.mariadb.name
}

# Utilisateur root MariaDB (à remplacer par Secret Manager)
resource "google_sql_user" "root" {
  name     = "root"
  project  = var.project_id
  instance = google_sql_database_instance.mariadb.name
  password = var.db_password
}