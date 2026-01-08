# ====================================
# Template d'instance
# ====================================
# Définit le modèle à partir duquel les instances seront créées
# Ce template contient la configuration machine, disque, réseau, etc.
resource "google_compute_instance_template" "default" {
    name_prefix = "instance-template-"
    description = "Instance template for managed instance group"

    # Type de machine (CPU/RAM)
    machine_type = var.machine_type

    # Configuration du disque de boot
    disk {
        source_image = var.source_image  # Image OS (ex: debian-11)
        auto_delete  = true               # Supprime le disque avec l'instance
        boot         = true               # Disque de démarrage
    }

    # Configuration réseau
    network_interface {
        network    = var.vpc_id       # VPC à utiliser
        subnetwork = var.subnetwork_id    # Sous-réseau à utiliser
    }

    # Métadonnées additionnelles (scripts de démarrage, tags, etc.)
    metadata = var.metadata

    # Compte de service pour les permissions GCP
    service_account {
        email  = var.service_account_email
        scopes = var.service_account_scopes
    }

    # Crée le nouveau template avant de supprimer l'ancien
    lifecycle {
        create_before_destroy = true
    }
}

# ====================================
# Groupe d'instances managé
# ====================================
# Gère automatiquement un groupe d'instances identiques
# Permet l'auto-scaling et l'auto-healing
resource "google_compute_instance_group_manager" "default" {
    name               = var.instance_group_name
    base_instance_name = var.base_instance_name  # Préfixe du nom des instances
    zone               = var.zone
    target_size        = var.target_size         # Nombre d'instances à maintenir

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
            initial_delay_sec = 300  # Délai avant le premier health check
        }
    }
}