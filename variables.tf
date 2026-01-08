variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "Région GCP pour les ressources"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "Zone GCP pour les ressources"
  type        = string
  default     = "europe-west1-b"
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
    service_account_scopes = list(string)
  }))
  default = {}
}

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
  description = "Configuration des VPC et sous-réseaux (bastion/frontend/backend)"
  type = map(object({
    vpc_name                    = string
    vpc_description             = string
    vpc_auto_create_subnetworks = bool
    subnetwork_name             = string
    subnetwork_ip_cidr_range    = string
  }))
}

variable "tier" {
  description = "The machine tier for Cloud SQL instance"
  type        = string
}

variable "network_tags" {
  description = "Liste des tags réseau à appliquer aux instances"
  type        = list(string)
  default     = []
}

variable "named_ports" {
  description = "Liste des ports nommés à configurer pour les groupes d'instances"
  type = list(object({
    name  = string
    ports = number
  }))
  default = []
  
#Load balancer
variable "proxy_subnet_ip_cidr_range" {
  type        = string
  description = "La plage d'adresse du sous-réseau des proxies"
}

variable "allow_proxy_target_tags" {
  type        = list(any)
  default     = []
  description = "description"
}

variable "firewall_proxy_prority" {
  type        = number
  description = "La priorité des règles liés au proxy"
}