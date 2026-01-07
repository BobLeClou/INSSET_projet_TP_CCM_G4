output "instance_name" {
  description = "Name of the backend instance"
  value       = google_compute_instance.backend.name
}

output "instance_id" {
  description = "ID of the backend instance"
  value       = google_compute_instance.backend.id
}

output "private_ip" {
  description = "Private IP address of the backend instance"
  value       = google_compute_instance.backend.network_interface[0].network_ip
}

output "self_link" {
  description = "Self link of the backend instance"
  value       = google_compute_instance.backend.self_link
}