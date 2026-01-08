# Zone DNS
resource "google_dns_managed_zone" "dns_managed_zone" {
  name     = var.dns_managed_zone_name
  dns_name = "groupe4.pierremalherbe.com."
}

# Enregistrement de l'adresse dans le DNS
resource "google_dns_record_set" "dns_record" {
  name         = google_dns_managed_zone.dns_managed_zone.dns_name
  managed_zone = google_dns_managed_zone.dns_managed_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [var.ip_load_balancer]
}