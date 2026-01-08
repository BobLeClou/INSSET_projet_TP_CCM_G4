resource "google_compute_network_peering" "peering_a_to_b" {
  name         = var.peering_name_a_to_b
  network      = var.network_a_id
  peer_network = var.network_b_id

  export_custom_routes = var.export_custom_routes
  import_custom_routes = var.import_custom_routes
}

resource "google_compute_network_peering" "peering_b_to_a" {
  name         = var.peering_name_b_to_a
  network      = var.network_b_id
  peer_network = var.network_a_id

  export_custom_routes = var.export_custom_routes
  import_custom_routes = var.import_custom_routes

  depends_on = [google_compute_network_peering.peering_a_to_b]
}
