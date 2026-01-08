#Subnetwork du proxy loadbalancer. /!\ DOIT ÊTRE SUR LE MÊME RÉSEAU QUE LES VM BACKEND VISÉS.
resource "google_compute_subnetwork" "proxy_subnet" {
  name          = "proxy-subnet"
  ip_cidr_range = "10.129.0.0/23"
  network       = google_compute_network.default.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}

#Règle de pare-feu permettant de communiquer avec les services de healthcheck Google Cloud
resource "google_compute_firewall" "fw_health_check" {
  name = "fw-allow-health-check"
  allow {
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.default.id
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["load-balanced-backend"]
}

#Règle de pare-feu reliant le proxy aux VM
resource "google_compute_firewall" "allow_proxy" {
  name = "fw-allow-proxies"
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
  network       = google_compute_network.default.id
  priority      = 1000
  source_ranges = ["10.129.0.0/23"]
  target_tags   = ["load-balanced-backend"]
}

#IP statique réservée au load balancer
resource "google_compute_address" "static_ip_load_balancer" {
  name         = "address-name-load-balancer"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}

#Health check, se charge de vérifier la disponibilité des VMs du backend
resource "google_compute_region_health_check" "lb_health_check" {
  name               = "l7-xlb-basic-check"
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

resource "google_compute_region_url_map" "lb_url_map" {
  name            = "regional-l7-xlb-map"
  default_service = google_compute_region_backend_service.lb_health_check.id
}

resource "google_compute_region_target_http_proxy" "lb_http_proxy" {
  name    = "l7-xlb-proxy"
  url_map = google_compute_region_url_map.lb_url_map.id
}

resource "google_compute_forwarding_rule" "lb_forwarding_rule" {
  name       = "l7-xlb-forwarding-rule"
  depends_on = [google_compute_subnetwork.proxy_only]
  region     = "us-west1"

  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.lb_http_proxy.id
  network               = google_compute_network.default.id
  ip_address            = google_compute_address.static_ip_load_balancer.id
  network_tier          = "STANDARD"
}