variable "vpc_name" {
  type        = string
  description = "Nom du VPC"
}

variable "vpc_description" {
  type        = string
  default     = ""
  description = "Description du VPC"
}

variable "vpc_auto_create_subnetworks" {
  type        = bool
  default     = false
  description = "Auto-génération des sous-réseaux. False par défaut."
}

variable "subnetwork_name" {
  type        = string
  description = "Nom du subnetwork"
}

variable "subnetwork_ip_cidr_range" {
  type        = string
  description = "Plage d'adresses réseaux utilisé par le sous-réseau"
}
