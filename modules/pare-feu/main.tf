resource "google_compute_firewall" "firewall" {
  name    = var.firewall_name
  network = var.firewall_network_name
  priority = var.firewall_priority
  direction = var.firewall_direction

  allow {
    protocol = var.firewall_protocol
    ports    = var.firewall_ports
  }

  source_ranges = var.firewall_source_ranges
  target_tags   = var.firewall_target_tags
}
