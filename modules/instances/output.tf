# ====================================
# Outputs du module Instances
# ====================================

# ID du template d'instance créé
output "instance_template_id" {
  description = "ID du template d'instance"
  value       = google_compute_instance_template.default.id
}

# Self-link du template d'instance
output "instance_template_self_link" {
  description = "Self-link du template d'instance"
  value       = google_compute_instance_template.default.self_link
}

# ID du groupe d'instances managé
output "instance_group_manager_id" {
  description = "ID du groupe d'instances managé"
  value       = google_compute_instance_group_manager.default.id
}

# Self-link du groupe d'instances
output "instance_group_self_link" {
  description = "Self-link du groupe d'instances"
  value       = google_compute_instance_group_manager.default.instance_group
}

# Nom du groupe d'instances
output "instance_group_name" {
  description = "Nom du groupe d'instances"
  value       = google_compute_instance_group_manager.default.name
}
