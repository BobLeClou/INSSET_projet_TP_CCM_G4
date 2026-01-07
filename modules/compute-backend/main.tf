resource "google_compute_instance" "backend" {
  project      = var.project_id
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      size  = 10
    }
  }

  network_interface {
    subnetwork = var.subnet_id
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  # Script de démarrage avec configuration Cloud SQL et Secret Manager
  metadata_startup_script = templatefile("${path.module}/startup-script.sh", {
    cloud_sql_connection_name = var.cloud_sql_connection_name
    cloud_sql_private_ip      = var.cloud_sql_private_ip
    db_user_secret            = var.secret_ids["db_user"]
    db_password_secret        = var.secret_ids["db_password"]
    db_name_secret            = var.secret_ids["db_name"]
    project_id                = var.project_id
  })

  tags = ["backend", "private"]

  labels = {
    environment = "dev"
    tier        = "backend"
  }
}