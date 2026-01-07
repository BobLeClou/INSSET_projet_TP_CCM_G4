# ====================================
# Module SA-IAM
# ====================================
# Ce module:
# 1) Crée un Service Account (SA)
# 2) Attribue des rôles IAM au niveau du projet à ce SA
#
# Il est conçu pour être appelé via for_each depuis le module racine.

resource "google_service_account" "sa" {
	# account_id: identifiant court (sans domaine)
	account_id   = var.service_account_id
	display_name = coalesce(var.display_name, var.service_account_id)
	description  = var.description
}

# Liaisons IAM au niveau projet pour le SA
# Utilisation de google_project_iam_member (non autoritatives) pour éviter
# d'écraser des bindings existants gérés ailleurs.
resource "google_project_iam_member" "sa_roles" {
	for_each = toset(var.roles)

	project = var.project_id
	role    = each.value
	member  = "serviceAccount:${google_service_account.sa.email}"
}

