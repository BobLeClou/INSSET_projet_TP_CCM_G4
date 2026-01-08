project_id = "g4-insset-projet-2025"
region     = "europe-west1"
zone       = "europe-west1-b"

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