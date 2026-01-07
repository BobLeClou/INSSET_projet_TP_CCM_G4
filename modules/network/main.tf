resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
  description = vpc.vpc_description
  auto_create_subnetworks = vpc.vpc_auto_create_subnetworks
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = var.subnetwork_name
  ip_cidr_range = var.subnetwork_ip_cidr_range
  network       = google_compute_network.vpc_network.id

  depends_on = [google_compute_network.vpc_network]
}