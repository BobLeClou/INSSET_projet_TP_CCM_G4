# ====================================
# OUTPUTS PRINCIPAUX
# ====================================

# Informations sur le réseau (délégué à une autre équipe)
# Note: le réseau n'est plus géré ici.
# Remplacez les placeholders dans inventories/dev/dev.tfvars.

# Informations sur les buckets
output "terraform_state_bucket" {
  description = "Nom du bucket pour le tfstate"
  value       = google_storage_bucket.terraform_state.name
}

# Informations sur les groupes d'instances (agrégées)
output "instance_group_names" {
  description = "Noms des groupes d'instances créés (par clé: frontend, backend, bastion, ...)"
  value       = { for k, m in module.instances_groups : k => m.instance_group_name }
}

# Instructions pour la suite
output "next_steps" {
  description = "Prochaines étapes après l'apply"
  value       = <<-EOT
    
    ✅ Infrastructure créée avec succès!
    
    📦 Ressources créées:
    - 2 buckets GCS (tfstate et app-data)
    - 1 VPC avec 3 sous-réseaux
    - 3 instances frontend
    - 3 instances backend
    - 1 instance bastion
    
    🔧 Prochaines étapes:
    1. Pour migrer le tfstate vers GCS:
       - Décommenter le bloc backend dans backend.tf
       - Exécuter: terraform init -migrate-state
    
    2. Pour voir les instances:
       gcloud compute instances list --project=${var.project_id}
    
    3. Pour se connecter au bastion:
       gcloud compute ssh bastion-xxxx --zone=${var.zone} --project=${var.project_id}
  EOT
}
