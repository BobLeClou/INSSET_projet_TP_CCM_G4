# ====================================
# Variables pour le module Instances
# ====================================

# Nom du groupe d'instances
variable "instance_group_name" {
  description = "Nom du groupe d'instances managé"
  type        = string
}

# Nom de base pour les instances créées
variable "base_instance_name" {
  description = "Préfixe du nom pour les instances (ex: front, back, bastion)"
  type        = string
}

# Zone GCP où déployer les instances
variable "zone" {
  description = "Zone GCP pour les instances"
  type        = string
}

# Nombre d'instances à créer dans le groupe
variable "target_size" {
  description = "Nombre d'instances à créer dans le groupe"
  type        = number
  default     = 1
}

# Type de machine (CPU/RAM)
variable "machine_type" {
  description = "Type de machine GCP (ex: e2-micro, e2-medium)"
  type        = string
  default     = "e2-micro"
}

# Image source pour le disque de boot
variable "source_image" {
  description = "Image source pour l'OS (ex: debian-cloud/debian-11)"
  type        = string
  default     = "debian-cloud/debian-11"
}

# Réseau VPC à utiliser
variable "vpc_id" {
  description = "Nom ou self_link du réseau VPC"
  type        = string
}

# Sous-réseau à utiliser
variable "subnetwork_id" {
  description = "Nom ou self_link du sous-réseau"
  type        = string
}

# Métadonnées à ajouter aux instances
variable "metadata" {
  description = "Métadonnées à attacher aux instances (tags, scripts, etc.)"
  type        = map(string)
  default     = {}
}

# Email du compte de service
variable "service_account_email" {
  description = "Email du compte de service à associer aux instances"
  type        = string
  default     = ""
}

# Scopes du compte de service
variable "service_account_scopes" {
  description = "Scopes d'autorisation pour le compte de service"
  type        = list(string)
  default     = ["cloud-platform"]
}

# ID du health check (optionnel)
variable "health_check_id" {
  description = "ID du health check pour l'auto-healing (optionnel)"
  type        = string
  default     = null
}
