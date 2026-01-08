output lb_ip_address {
  value       = google_compute_address.static_ip_load_balancer.address
  description = "description"
  depends_on  = [google_compute_address.static_ip_load_balancer]
}
