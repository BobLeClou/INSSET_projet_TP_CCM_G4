#Subnetwork du proxy loadbalancer. /!\ DOIT ÊTRE SUR LE MÊME RÉSEAU QUE LES VM BACKEND VISÉS.
resource "google_compute_subnetwork" "proxy_subnet" {
<<<<<<< HEAD
  name          = var.proxy_subnet_name
=======
  name          = "proxy-subnet"
>>>>>>> 8cea8a6 (Definition des variables du load balancer)
  ip_cidr_range = var.proxy_subnet_ip_cidr_range
  network       = var.proxy_subnet_network
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}

#Règle de pare-feu permettant de communiquer avec les services de healthcheck Google Cloud
resource "google_compute_firewall" "fw_health_check" {
  name = var.fw_health_check_name
  allow {
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = var.proxy_subnet_network
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = var.allow_proxy_target_tags
}

#Règle de pare-feu reliant le proxy aux VM
resource "google_compute_firewall" "allow_proxy" {
  name = var.allow_proxy_name
  allow {
    ports    = ["443"]
    protocol = "tcp"
  }
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
  allow {
    ports    = ["8080"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = var.proxy_subnet_network
  priority      = var.firewall_proxy_prority
  source_ranges = [var.proxy_subnet_ip_cidr_range]
<<<<<<< HEAD
  target_tags   = var.allow_proxy_target_tags
=======
  target_tags   = ["load-balanced-backend"]
>>>>>>> 8cea8a6 (Definition des variables du load balancer)
}

#IP statique réservée au load balancer
resource "google_compute_address" "static_ip_load_balancer" {
  name         = var.static_ip_load_balancer_name
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}

#Health check, se charge de vérifier la disponibilité des VMs du backend
resource "google_compute_region_health_check" "lb_health_check" {
  name               = var.lb_health_check_name
  check_interval_sec = 5
  healthy_threshold  = 2
  http_health_check {
    port_specification = "USE_SERVING_PORT"
    proxy_header       = "NONE"
    request_path       = "/"
  }
  timeout_sec         = 5
  unhealthy_threshold = 2
}

<<<<<<< HEAD
resource "google_compute_region_backend_service" "lb_backend_service" {
  name                  = var.lb_backend_service_name
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks         = [google_compute_region_health_check.lb_health_check.id]
  protocol              = "HTTP"
  session_affinity      = "NONE"
  timeout_sec           = 30
  backend {
    group           = var.lb_backend_service_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

#URL Map pour redistribuer la requête vers la bonne VM
resource "google_compute_region_url_map" "lb_url_map" {
  name            = var.lb_url_map_name
  default_service = google_compute_region_backend_service.lb_backend_service.id
}

=======
#URL Map pour redistribuer la requête vers la bonne VM
resource "google_compute_region_url_map" "lb_url_map" {
  name            = "regional-l7-xlb-map"
  default_service = google_compute_region_backend_service.lb_health_check.id
}

>>>>>>> 8cea8a6 (Definition des variables du load balancer)
#Proxy HTTP
resource "google_compute_region_target_http_proxy" "lb_http_proxy" {
  name    = var.lb_http_proxy_name
  url_map = google_compute_region_url_map.lb_url_map.id
}

#Règle de renvoi de la requête
resource "google_compute_forwarding_rule" "lb_forwarding_rule" {
<<<<<<< HEAD
  name       = var.lb_forwarding_rule_name
=======
  name       = "l7-xlb-forwarding-rule"
>>>>>>> 8cea8a6 (Definition des variables du load balancer)
  depends_on = [google_compute_subnetwork.proxy_subnet]

  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.lb_http_proxy.id
  network               = var.proxy_subnet_network
  ip_address            = google_compute_address.static_ip_load_balancer.id
  network_tier          = "STANDARD"
}