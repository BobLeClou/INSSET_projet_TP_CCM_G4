output "instance_group_names" {
  description = "Noms des groupes d'instances créés (par clé: frontend, backend, bastion, ...)"
  value       = { for k, m in module.instances_groups : k => m.instance_group_name }
}

output "service_accounts_emails" {
  description = "Emails des service accounts par clé"
  value = {
    for k, m in module.service_accounts : k => m.email
  }
}