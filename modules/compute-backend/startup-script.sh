#!/bin/bash

# Installation des dépendances
apt-get update
apt-get install -y curl wget mysql-client

# Installation de gcloud CLI si nécessaire
if ! command -v gcloud &> /dev/null; then
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    apt-get update && apt-get install -y google-cloud-cli
fi

# Récupération des secrets depuis Secret Manager
export DB_USER=$(gcloud secrets versions access latest --secret="${db_user_secret}" --project="${project_id}")
export DB_PASSWORD=$(gcloud secrets versions access latest --secret="${db_password_secret}" --project="${project_id}")
export DB_NAME=$(gcloud secrets versions access latest --secret="${db_name_secret}" --project="${project_id}")
export DB_HOST="${cloud_sql_private_ip}"
export DB_PORT="3306"

# Sauvegarde des variables d'environnement pour l'application
cat > /etc/environment.d/database.conf <<EOF
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_NAME=$DB_NAME
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
EOF

# Test de connexion à MYSQL
echo "Testing MYSQL connection..."
mysql -h ${cloud_sql_private_ip} -u $DB_USER -p$DB_PASSWORD -e "SHOW DATABASES;" || echo "Connection failed"

echo "Backend startup completed"