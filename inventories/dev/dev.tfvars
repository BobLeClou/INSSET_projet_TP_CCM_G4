# Projet et localisation GCP
project_id = "g4-insset-projet-2025"
region     = "europe-west1"
zone       = "europe-west1-b"
tier       = "db-n1-standard-1"


# ====================================
instance_groups = {
  frontend = {
    instance_group_name = "g4-insset-projet-2025-frontend-group"
    base_instance_name  = "frontend"
    zone                = "europe-west1-b"
    target_size         = 3
    machine_type        = "e2-micro"
    source_image        = "debian-cloud/debian-11"

    vpc_id        = "vpc-front"
    subnetwork_id = "subnet-front"
    named_ports = [
      { name = "http", ports = 80 }
    ]
    network_tags = ["frontend"]

    metadata = {
      startup-script = <<-EOT
				#!/bin/bash
				apt-get update
				apt-get install -y nginx
				systemctl start nginx
				systemctl enable nginx
				echo "Frontend instance ready" > /var/www/html/index.html
			EOT
    }
    service_account_scopes = ["cloud-platform"]
  }

  backend = {
    instance_group_name = "g4-insset-projet-2025-backend-group"
    base_instance_name  = "backend"
    zone                = "europe-west1-b"
    target_size         = 3
    machine_type        = "e2-micro"
    source_image        = "debian-cloud/debian-11"

    vpc_id        = "vpc-back"
    subnetwork_id = "subnet-back"
    named_ports   = []
    network_tags  = null

    metadata = {
      startup-script = <<-EOT
				#!/bin/bash
				apt-get update
				apt-get install -y python3 python3-pip
				echo "Backend instance ready" > /tmp/backend_ready.txt
			EOT
    }
    service_account_scopes = ["cloud-platform"]
  }

  bastion = {
    instance_group_name = "g4-insset-projet-2025-bastion-group"
    base_instance_name  = "bastion"
    zone                = "europe-west1-b"
    target_size         = 1
    machine_type        = "e2-micro"
    source_image        = "debian-cloud/debian-11"

    vpc_id        = "vpc-bastion"
    subnetwork_id = "subnet-bastion"

    named_ports  = []
    network_tags = null

    metadata = {
      startup-script = <<-EOT
				#!/bin/bash
				apt-get update
				apt-get install -y curl wget vim
				echo "Bastion instance ready" > /tmp/bastion_ready.txt
			EOT
    }
    service_account_scopes = ["cloud-platform"]
  }
}

# ====================================
# Service Accounts (exemples DEV)
# ====================================
service_accounts = {

  backend_sa = {
    account_id   = "backend-service-account"
    display_name = "Backend Service Account"
    description  = "Compte de service pour les instances backend"
    roles = [
      "roles/cloudsql.client",
      "roles/secretmanager.secretAccessor"
    ]
  }
  bastion_sa = {
    account_id   = "bastion-service-account"
    display_name = "Bastion Service Account"
    description  = "Compte de service pour les instances bastion"
    roles = [
      "roles/logging.logWriter"
    ]
  }
  frontend_sa = {
    account_id   = "frontend-service-account"
    display_name = "Frontend Service Account"
    description  = "Compte de service pour les instances frontend"
    roles = [
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter"
    ]
  }
  manager_sa = {
    account_id   = "manager-service-account"
    display_name = "Manager Service Account"
    description  = "Compte de service pour l'administrateur"
    roles = [
      "roles/secretmanager.admin",
      "roles/cloudsql.admin",
      "roles/compute.instanceAdmin.v1"
    ]
  }
}

# Déclaration des réseaux et sous-réseaux
networks = {
  bastion = {
    vpc_name                    = "vpc-bastion"
    vpc_description             = "Réseau du bastion, uniquement accessible par les développeurs, porte d'entrée vers les instances front/back."
    vpc_auto_create_subnetworks = false
    subnetwork_name             = "subnet-bastion"
    subnetwork_ip_cidr_range    = "10.0.1.0/24"
  }

  front = {
    vpc_name                    = "vpc-front"
    vpc_description             = "Réseau des instances front."
    vpc_auto_create_subnetworks = false
    subnetwork_name             = "subnet-front"
    subnetwork_ip_cidr_range    = "10.0.2.0/24"
  }

  back = {
    vpc_name                    = "vpc-back"
    vpc_description             = "Réseau des instances back."
    vpc_auto_create_subnetworks = false
    subnetwork_name             = "subnet-back"
    subnetwork_ip_cidr_range    = "10.0.3.0/24"
  }

  cloudsql = {
    vpc_name                    = "vpc-cloudsql"
    vpc_description             = "Réseau de la base de données et de ses sauvegardes."
    vpc_auto_create_subnetworks = false
    subnetwork_name             = "subnet-cloudsql"
    subnetwork_ip_cidr_range    = "10.0.4.0/24"
  }

  public-access = {
    vpc_name                    = "vpc-public-access"
    vpc_description             = "Réseau du DNS et du Load Balancer."
    vpc_auto_create_subnetworks = false
    subnetwork_name             = "subnet-public-access"
    subnetwork_ip_cidr_range    = "10.0.5.0/24"
  }
}

firewall_rules = {
  # Règles existantes (vpc-front pour LB)
  fw-allow-proxies = {
    firewall_name          = "fw-allow-proxies"
    firewall_network_name  = "vpc-front"
    firewall_priority      = 1099
    firewall_protocol      = "tcp"
    firewall_ports         = [80, 443, 8080]
    firewall_source_ranges = ["10.0.6.0/24"]  # Proxy subnet LB
    firewall_target_tags   = ["frontend"]
    firewall_direction     = "INGRESS"
  }
  fw-allow-health-check = {
    firewall_name          = "fw-allow-health-check"
    firewall_network_name  = "vpc-front"
    firewall_priority      = 1000
    firewall_protocol      = "tcp"
    firewall_ports         = []  # Port serving (healthcheck auto)
    firewall_source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
    firewall_target_tags   = ["frontend"]
    firewall_direction     = "INGRESS"
  }

  # Règles ingress proposées (internes)
  fw-front-to-back = {
    firewall_name          = "fw-front-to-back"
    firewall_network_name  = "vpc-front"
    firewall_priority      = 1100
    firewall_protocol      = "tcp"
    firewall_ports         = [8080]
    firewall_source_ranges = ["10.0.2.0/24"]  # Subnet front
    firewall_target_tags   = ["backend"]
    firewall_direction     = "INGRESS"
  }
  fw-back-to-db = {
    firewall_name          = "fw-back-to-db"
    firewall_network_name  = "vpc-back"
    firewall_priority      = 1101
    firewall_protocol      = "tcp"
    firewall_ports         = [3306]
    firewall_source_ranges = ["10.0.3.0/24"]  # Subnet back
    firewall_target_tags   = ["private"]
    firewall_direction     = "INGRESS"
  }
  fw-bastion-to-back = {
    firewall_name          = "fw-bastion-to-back"
    firewall_network_name  = "vpc-bastion"
    firewall_priority      = 1102
    firewall_protocol      = "tcp"
    firewall_ports         = [22, 8080]
    firewall_source_ranges = ["10.0.1.0/24"]  # Subnet bastion
    firewall_target_tags   = ["backend"]
    firewall_direction     = "INGRESS"
  }
  fw-bastion-ssh = {
    firewall_name          = "fw-bastion-ssh"
    firewall_network_name  = "vpc-bastion"
    firewall_priority      = 1103
    firewall_protocol      = "tcp"
    firewall_ports         = [22]
    firewall_source_ranges = ["0.0.0.0/0"]  # Restreignez à IPs devs (ex. "82.64.0.0/18")
    firewall_target_tags   = ["bastion"]
    firewall_direction     = "INGRESS"
  }

  # Règles egress limitées (optionnel, default GCP=allow all)
  fw-egress-back-updates = {
    firewall_name          = "fw-egress-back-updates"
    firewall_network_name  = "vpc-back"
    firewall_priority      = 1000
    firewall_protocol      = "tcp"
    firewall_ports         = [443, 80]
    firewall_source_ranges = ["10.0.3.0/24"]
    firewall_target_tags   = []  # Applique à toute VM back
    firewall_direction     = "EGRESS"
  }
}

