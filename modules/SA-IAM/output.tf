# ====================================
# Outputs du module SA-IAM
# ====================================

output "service_account_email" {
  description = "Email du Service Account"
  value       = google_service_account.sa.email
}

output "service_account_unique_id" {
  description = "Unique ID du Service Account"
  value       = google_service_account.sa.unique_id
}

output "applied_roles" {
  description = "Rôles IAM appliqués au SA (niveau projet)"
  value       = [for r in google_project_iam_member.sa_roles : r.role]
}

