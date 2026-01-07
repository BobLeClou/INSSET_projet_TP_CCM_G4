output vpc_id {
  value       = google_compute_network.vpc_network.id
  description = "L'id du vpc créé"
}

output subnetwork_id {
  value       = google_compute_network.vpc_network.id
  description = "L'id du vpc créé"
}
