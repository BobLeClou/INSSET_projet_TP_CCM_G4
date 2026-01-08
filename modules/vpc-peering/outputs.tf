output "peering_a_to_b_id" {
  description = "ID du peering A vers B"
  value       = google_compute_network_peering.peering_a_to_b.id
}

output "peering_b_to_a_id" {
  description = "ID du peering B vers A"
  value       = google_compute_network_peering.peering_b_to_a.id
}

output "peering_state" {
  description = "État du peering"
  value       = google_compute_network_peering.peering_a_to_b.state
}