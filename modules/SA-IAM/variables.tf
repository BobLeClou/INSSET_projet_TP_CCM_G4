# ====================================
# Variables du module SA-IAM
# ====================================

# Projet cible (utile pour les liaisons IAM project-level)
variable "project_id" {
	description = "ID du projet GCP"
	type        = string
}

# Identifiant technique du Service Account (partie avant @)
# Ex: account_id = "sa-app" => email: sa-app@project.iam.gserviceaccount.com
variable "service_account_id" {
	description = "Identifiant technique du Service Account (account_id)"
	type        = string
}

# Nom d'affichage du Service Account
variable "display_name" {
	description = "Nom d'affichage du Service Account"
	type        = string
	default     = null
}

# Description optionnelle
variable "description" {
	description = "Description du Service Account"
	type        = string
	default     = null
}

# Rôles IAM à attribuer au Service Account au niveau du projet
# Exemple: ["roles/storage.objectAdmin", "roles/logging.logWriter"]
variable "roles" {
	description = "Liste des rôles IAM à attribuer au SA (niveau projet)"
	type        = list(string)
	default     = []
}

