variable "project_id" {
  description = "ID du projet GCP"
  type        = string
  default     = "g4-insset-projet-2025"
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
    instance_group_name    = optional(string)
    base_instance_name     = optional(string)
    zone                   = optional(string)
    target_size            = optional(number)
    machine_type           = optional(string)
    source_image           = optional(string)
    vpc_id                 = optional(string)
    subnetwork_id          = optional(string)
    metadata               = optional(map(string))
    service_account_email  = optional(list(string))
    service_account_scopes = optional(list(string))
    health_check_id        = optional(string)
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
}

variable "firewall_rules" {
  description = "Map des règles de pare-feu à créer"
  type = map(object({
    firewall_name          = string
    firewall_network_name  = string
    firewall_priority      = optional(number, 1000)
    firewall_protocol      = string
    firewall_ports         = optional(list(number), [])
    firewall_source_ranges = list(string)
    firewall_target_tags   = optional(list(string), [])
  }))
  default = {} 
}
variable "firewall_name" {
  description = "Name of the firewall rule"
  type        = string
  default     = null
}

variable "firewall_network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = null
}

variable "firewall_priority" {
  description = "Priority of the firewall rule (lower numbers = higher priority)"
  type        = number
  default     = 1000
}

variable "firewall_protocol" {
  description = "Protocol for the firewall rule (tcp, udp, icmp, etc.)"
  type        = string
  default     = null
}

variable "firewall_ports" {
  description = "List of ports for the firewall rule"
  type        = list(number)
  default     = []
}

variable "firewall_source_ranges" {
  description = "List of source CIDR ranges"
  type        = list(string)
  default     = []
}

variable "firewall_target_tags" {
  description = "List of target tags for the firewall rule"
  type        = list(string)
  default     = []
}

variable "firewall_direction" {
  description = "Direction of the firewall rule (INGRESS(entry) or EGRESS(sortie))"
  type        = string
  default     = "INGRESS"
}

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