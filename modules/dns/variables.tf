variable "dns_managed_zone_name" {
  type        = string
  description = "Le nom de la zone DNS"
}

variable "ip_load_balancer" {
  type        = string
  description = "L'IP du load balancer vers lequel pointe le DNS"
}