## Description
Projet Terraform pour déployer une infrastructure GCP avec des buckets de stockage.

## Prérequis
- Terraform >= 1.0
- Google Cloud SDK configuré
- Un projet GCP actif

## Installation
1. Clonez le repository
2. Naviguez dans le répertoire du projet
3. Exécutez les commandes suivantes :

```bash
terraform init
terraform plan -var-file=inventories/dev/dev.tfvars
terraform apply -var-file=inventories/dev/dev.tfvars
```

## Structure du projet
- `provider.tf` : Configuration du provider Google Cloud
- `variables.tf` : Déclaration des variables
- `main.tf` : Ressources principales (buckets GCS)
- `inventories/dev/dev.tfvars` : Variables d'environnement développement

## Variables
- `project_id` : ID du projet GCP
- `region` : Région GCP (par défaut: europe-west1)
- `zone` : Zone GCP (par défaut: europe-west1-b)
