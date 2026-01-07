resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
  description = vpc.vpc_description
  auto_create_subnetworks = vpc.auto_create_subnetworks
}