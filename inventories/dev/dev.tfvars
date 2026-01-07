# ====================================
# Configuration environnement DEV
# ====================================

# Projet et localisation GCP
project_id = "g4-insset-projet-2025"
region     = "europe-west1"
zone       = "europe-west1-b"

# ====================================
# Groupes d'instances à créer (DEV)
# ====================================
# Le réseau est géré par une autre équipe.
# Utilisez des placeholders explicites à remplacer ensuite.
instance_groups = {
	frontend = {
		instance_group_name = "${project_id}-frontend-group"
		base_instance_name  = "frontend"
		zone                = zone
		target_size         = 3
		machine_type        = "e2-micro"
		source_image        = "debian-cloud/debian-11"

		# Placeholders réseau à remplacer
		vpc_id        = "vpc-front"
		subnetwork_id = "subnet-front"

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
        service_account_email = "A CHANGER-service-account-email"
        service_account_scopes = ["cloud-platform"]
	}

	backend = {
		instance_group_name = "${project_id}-backend-group"
		base_instance_name  = "backend"
		zone                = zone
		target_size         = 3
		machine_type        = "e2-micro"
		source_image        = "debian-cloud/debian-11"

		# Placeholders réseau à remplacer
		vpc_id        = "vpc-back"
		subnetwork_id = "subnet-back"

		metadata = {
			startup-script = <<-EOT
				#!/bin/bash
				apt-get update
				apt-get install -y python3 python3-pip
				echo "Backend instance ready" > /tmp/backend_ready.txt
			EOT
		}
	}

	bastion = {
		instance_group_name = "${project_id}-bastion-group"
		base_instance_name  = "bastion"
		zone                = zone
		target_size         = 1
		machine_type        = "e2-micro"
		source_image        = "debian-cloud/debian-11"

		# Placeholders réseau à remplacer
		vpc_id        = "vpc-bastion"
		subnetwork_id = "subnet-bastion"

		metadata = {
			startup-script = <<-EOT
				#!/bin/bash
				apt-get update
				apt-get install -y curl wget vim
				echo "Bastion instance ready" > /tmp/bastion_ready.txt
			EOT
		}
	}
}

# ====================================
# Service Accounts (exemples DEV)
# ====================================
service_accounts = {
	sa-app = {
		# Si omis, account_id = clé de la map (ici "sa-app")
		account_id   = "sa-app"
		display_name = "SA Application"
		description  = "Compte de service pour l'application"
		roles        = [
			"roles/storage.objectAdmin",
			"roles/logging.logWriter"
		]
	}

	sa-ci = {
		account_id   = "sa-ci"
		display_name = "SA CI/CD"
		description  = "Compte de service pour pipeline CI/CD"
		roles        = [
			"roles/storage.admin",
			"roles/iam.serviceAccountUser"
		]
	}
}