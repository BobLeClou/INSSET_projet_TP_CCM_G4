resource "google_compute_instance_template" "default" {
  name_prefix = "instance-template-"
  description = "Instance template for managed instance group"

  machine_type = var.machine_type

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnetwork_id
  }

  metadata = var.metadata

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }
  lifecycle {
    create_before_destroy = true
  }

  tags = var.network_tags
}

resource "google_compute_instance_group_manager" "default" {
  name               = var.instance_group_name
  base_instance_name = var.base_instance_name # Préfixe du nom des instances
  zone               = var.zone
  target_size        = var.target_size # Nombre d'instances à maintenir

  named_port {
    name = length(var.named_ports) > 0 ? var.named_ports[0].name : "dummy"
    port = length(var.named_ports) > 0 ? var.named_ports[0].ports : 65534
  }

  # Version du template à utiliser
  version {
    instance_template = google_compute_instance_template.default.id
  }

  # Politique d'auto-healing (optionnelle)
  # Relance automatiquement les instances défaillantes
  dynamic "auto_healing_policies" {
    for_each = var.health_check_id != null ? [1] : []
    content {
      health_check      = var.health_check_id
      initial_delay_sec = 300 # Délai avant le premier health check
    }
  }
}