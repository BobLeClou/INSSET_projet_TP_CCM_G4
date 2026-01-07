variable vpc_name {
  type        = string
  description = "Nom du VPC"
}

variable vpc_description {
  type        = string
  default     = ""
  description = "Description du VPC"
}

variable auto_create_subnetworks {
  type        = bool
  default     = false
  description = "Auto-génération des sous-réseaux. False par défaut."
}
