variable proxy_subnet_ip_cidr_range {
  type        = string
  description = "La plage d'adresse du sous-réseau des proxies"
}

variable proxy_subnet_network {
  type        = string
  description = "L'id du réseau dont fait partie le backend et le proxy"
}

variable firewall_proxy_prority {
  type        = number
  description = "La priorité des règles liés au proxy"
}
