variable "peering_name_a_to_b" {
  description = "Nom du peering de A vers B"
  type        = string
}

variable "peering_name_b_to_a" {
  description = "Nom du peering de B vers A"
  type        = string
}

variable "network_a_id" {
  description = "ID du VPC A (self_link)"
  type        = string
}

variable "network_b_id" {
  description = "ID du VPC B (self_link)"
  type        = string
}

variable "export_custom_routes" {
  description = "Exporter les routes personnalisées"
  type        = bool
  default     = false
}

variable "import_custom_routes" {
  description = "Importer les routes personnalisées"
  type        = bool
  default     = false
}
