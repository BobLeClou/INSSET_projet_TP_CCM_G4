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

output "service_accounts_emails" {
  description = "Emails des SAs, indexés par clé"
  value = {
    for k, m in module.service_accounts :
    k => m.email
  }
}
