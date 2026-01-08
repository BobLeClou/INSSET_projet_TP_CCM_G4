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