# 🚀 Infrastructure GCP - Projet INSSET G4

Infrastructure as Code pour déployer une architecture multi-tiers sur Google Cloud Platform avec Terraform.

## 📋 Architecture

```
┌─────────────────────────────────────────────────────┐
│                    Internet                         │
└──────────────────┬──────────────────────────────────┘
                   │
        ┌──────────┴──────────┐
        │    Load Balancer    │ (futur)
        └──────────┬──────────┘
                   │
    ┌──────────────┴──────────────┐
    │     Frontend Subnet         │
    │    (10.0.1.0/24)            │
    │  ┌────┐ ┌────┐ ┌────┐      │
    │  │ F1 │ │ F2 │ │ F3 │      │ 3x VMs Frontend
    │  └────┘ └────┘ └────┘      │
    └──────────────┬──────────────┘
                   │
    ┌──────────────┴──────────────┐
    │     Backend Subnet          │
    │    (10.0.2.0/24)            │
    │  ┌────┐ ┌────┐ ┌────┐      │
    │  │ B1 │ │ B2 │ │ B3 │      │ 3x VMs Backend
    │  └────┘ └────┘ └────┘      │
    └─────────────────────────────┘
    
    ┌─────────────────────────────┐
    │    Bastion Subnet           │
    │   (10.0.3.0/24)             │
    │       ┌────────┐            │
    │       │Bastion │            │ 1x VM Bastion
    │       └────────┘            │
    └─────────────────────────────┘
```

## 🗂️ Structure du projet

```
.
├── main.tf                 # Point d'entrée principal - Appel des modules
├── variables.tf            # Déclaration des variables globales
├── outputs.tf             # Sorties après apply
├── provider.tf            # Configuration du provider GCP
├── backend.tf             # Configuration du backend distant (GCS)
├── inventories/
│   └── dev/
│       └── dev.tfvars     # Valeurs des variables pour l'env DEV
└── modules/
    ├── network/           # Module réseau (VPC, subnets, firewall)
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── instances/         # Module instances (templates + groups)
        ├── main.tf
        ├── variables.tf
        └── output.tf
```

## 🔧 Ressources créées

### Buckets GCS
- **terraform-state** : Stockage du fichier tfstate (avec versioning)
- **app-data** : Bucket générique pour l'application

### Réseau
- **1 VPC** personnalisé
- **3 sous-réseaux** :
  - Frontend (10.0.1.0/24)
  - Backend (10.0.2.0/24)
  - Bastion (10.0.3.0/24)
- **Règles firewall** :
  - SSH vers bastion depuis Internet
  - HTTP/HTTPS vers frontend
  - Communication interne entre tous les sous-réseaux

### Instances
- **3 VMs Frontend** : Serveur web (Nginx)
- **3 VMs Backend** : API/logique métier
- **1 VM Bastion** : Point d'entrée SSH sécurisé

## 🚀 Utilisation

### Prérequis

1. Installer Terraform (>= 1.0)
2. Installer gcloud CLI
3. S'authentifier sur GCP :
```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project g4-insset-projet-2025
```

4. Activer les APIs nécessaires :
```bash
gcloud services enable compute.googleapis.com
gcloud services enable storage.googleapis.com
```

### Premier déploiement

1. **Initialiser Terraform** :
```bash
terraform init
```

2. **Vérifier le plan** :
```bash
terraform plan -var-file=inventories/dev/dev.tfvars
```

3. **Déployer l'infrastructure** :
```bash
terraform apply -var-file=inventories/dev/dev.tfvars
```

4. **Migrer le tfstate vers GCS** (après le premier apply réussi) :
```bash
# Décommenter le bloc backend dans backend.tf
# Puis exécuter :
terraform init -migrate-state
```

### Commandes utiles

```bash
# Lister les instances créées
gcloud compute instances list --project=g4-insset-projet-2025

# Se connecter au bastion
gcloud compute ssh bastion-xxxx --zone=europe-west1-b

# Voir les outputs
terraform output

# Détruire l'infrastructure
terraform destroy -var-file=inventories/dev/dev.tfvars
```

## 📝 Customisation

### Modifier le nombre d'instances

Dans [inventories/dev/dev.tfvars](inventories/dev/dev.tfvars), ou directement dans le [main.tf](main.tf) :
```hcl
# Dans le module frontend_instances
target_size = 5  # Change 3 en 5 pour avoir 5 frontends
```

### Modifier le type de machine

Dans [inventories/dev/dev.tfvars](inventories/dev/dev.tfvars) :
```hcl
frontend_machine_type = "e2-medium"  # Plus puissant que e2-micro
```

### Ajouter des métadonnées/scripts

Dans [variables.tf](variables.tf), modifier les scripts de démarrage :
```hcl
variable "frontend_startup_script" {
  default = <<-EOT
    #!/bin/bash
    # Votre script personnalisé ici
  EOT
}
```

## 🔒 Sécurité

⚠️ **Points d'attention en production** :

1. **Firewall SSH** : Restreindre l'accès SSH au bastion à votre IP :
```hcl
source_ranges = ["VOTRE_IP/32"]  # Au lieu de 0.0.0.0/0
```

2. **Bucket tfstate** : `prevent_destroy = true` est activé
3. **Service Account** : Créer un SA dédié avec des permissions minimales
4. **Secrets** : Ne jamais commiter de credentials dans le code

## 📚 Documentation

- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [GCP Compute Engine](https://cloud.google.com/compute/docs)
- [GCP VPC](https://cloud.google.com/vpc/docs)

## 👥 Auteurs

Groupe 4 - INSSET 2025
iSreaK - Julien
BobLeClou - Kerrian
ValentinDuval - Valentin

---

💡 **Astuce** : Utiliser `terraform plan` avant chaque apply pour voir les changements!
