variable "firewall_name" {
    description = "Name of the firewall rule"
    type        = string
}

variable "firewall_network_name" {
    description = "Name of the VPC network"
    type        = string
}

variable "firewall_priority" {
    description = "Priority of the firewall rule (lower numbers = higher priority)"
    type        = number
    default     = 1000
}

variable "firewall_protocol" {
    description = "Protocol for the firewall rule (tcp, udp, icmp, etc.)"
    type        = string
}

variable "firewall_ports" {
    description = "List of ports for the firewall rule"
    type        = list(number)
    default     = []
}

variable "firewall_source_ranges" {
    description = "List of source CIDR ranges"
    type        = list(string)
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