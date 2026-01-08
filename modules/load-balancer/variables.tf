# ---------------------------
# --- NOMS DES RESSOURCES ---
# ---------------------------
variable "proxy_subnet_name" {
  type        = string
  default     = "proxy-subnet"
  description = "Nom du proxy du subnet"
}

variable "fw_health_check_name" {
  type        = string
  default     = "fw-allow-health-check"
  description = "Nom de la règle firewall du health check"
}

variable "allow_proxy_name" {
  type        = string
  default     = "fw-allow-proxies"
  description = "Nom de la règle firewall du proxy"
}

variable "static_ip_load_balancer_name" {
  type        = string
  default     = "address-name-load-balancer"
  description = "Nom de l'attribution d'ip statique du proxy"
}

variable "lb_backend_service_name" {
  type        = string
  default     = "l7-xlb-backend-service"
  description = "Nom du service backend"
}

variable "lb_health_check_name" {
  type        = string
  default     = "l7-xlb-basic-check"
  description = "Nom du health check"
}

variable "lb_url_map_name" {
  type        = string
  default     = "regional-l7-xlb-map"
  description = "Nom du plan d'URL"
}

variable "lb_http_proxy_name" {
  type        = string
  default     = "l7-xlb-proxy"
  description = "Nom du proxy http"
}

variable "lb_forwarding_rule_name" {
  type        = string
  default     = "l7-xlb-forwarding-rule"
  description = "Nom de la règle de renvoi"
}

# ------------------------
# --- AUTRES VARIABLES ---
# ------------------------
variable "proxy_subnet_ip_cidr_range" {
  type        = string
  description = "La plage d'adresse du sous-réseau des proxies"
}

variable "proxy_subnet_network" {
  type        = string
  description = "L'id du réseau dont fait partie le backend et le proxy"
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

variable "lb_backend_service_group" {
  type        = string
  description = "La valeur 'instance_group' du group manager supervisé"
}