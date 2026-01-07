variable "project_id" {
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
