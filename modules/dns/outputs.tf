output dns_managed_zone_id {
    value = google_dns_managed_zone.dns_managed_zone.id
    description = 
}

output dns_record_id {
  value       = google_dns_record_set.dns_record.id
  description = "Id de l'enregistrement du DNS"
}
