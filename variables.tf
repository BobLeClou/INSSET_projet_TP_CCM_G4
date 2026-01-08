variable "project_id" {
  description = "The GCP project ID"
  type        = string
}
variable "region" {
  description = "The GCP region"
  type        = string
}
variable "zone" {
  description = "The GCP zone"
  type        = string
    description = "ID du projet GCP"
    type        = string  
    default = "g4-insset-projet-2025"
}
variable "region" {
    description = "Région GCP pour les ressources"
    type        = string  
    default = "europe-west1"
}

variable "zone" {
    description = "Zone GCP pour les ressources"
    type        = string  
    default = "europe-west1-b"
}

variable "instance_groups" {
  description = "Configuration des groupes d'instances à créer"
  type = map(object({
    instance_group_name = string
    base_instance_name  = string
    zone                = string
    target_size         = number
    machine_type        = string
    source_image        = string
    vpc_id              = string
    subnetwork_id       = string
    metadata = object({
      startup-script = string
    })
  }))
    default = {}
}

# ====================================
# Service Accounts + IAM (map pour for_each)
# ====================================
# Permet de définir plusieurs comptes de service et leurs rôles projet.
# Exemple de structure dans un tfvars:
# service_accounts = {
#   sa-app = {
#     account_id   = "sa-app"
#     display_name = "SA Application"
#     description  = "Compte de service pour l'app"
#     roles        = ["roles/storage.objectAdmin", "roles/logging.logWriter"]
#   }
# }
variable "service_accounts" {
  description = "Map des Service Accounts à créer et rôles à appliquer"
  type = map(object({
    account_id   = optional(string)
    display_name = optional(string)
    description  = optional(string)
    roles        = optional(list(string), [])
  }))
  default = {}
}

variable "networks" {
  description = "La déclaration des réseaux"
  type        = map(any)
}