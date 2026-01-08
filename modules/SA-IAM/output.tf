# ====================================
# Outputs du module SA-IAM
# ====================================

output "service_account_email" {
  description = "Email du Service Account"
  value       = google_service_account.sa.email
}

output "email" {
  description = "Email du service account"
  value       = google_service_account.sa.email
}


output "applied_roles" {
  description = "Rôles IAM appliqués au SA (niveau projet)"
  value       = [for r in google_project_iam_member.sa_roles : r.role]
}

