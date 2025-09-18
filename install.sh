#!/usr/bin/env bash
set -euo pipefail

echo ">>> 🚀 Installation de MediaStack sur Proxmox LXC"

# Mise à jour
apt-get update && apt-get upgrade -y
apt-get install -y curl unzip git

# Installation Docker + Compose
if ! command -v docker &> /dev/null; then
  echo ">>> 🐳 Installation de Docker..."
  curl -fsSL https://get.docker.com | sh
  apt-get install -y docker-compose-plugin
fi

# Téléchargement du projet
echo ">>> 📦 Téléchargement de mediastack..."
cd /opt
curl -L https://github.com/ipm32informatique-32/mediastack/archive/refs/heads/main.zip -o mediastack.zip
unzip -o mediastack.zip
rm mediastack.zip
mv mediastack-main mediastack || true

# Déploiement
echo ">>> 🚀 Lancement de MediaStack..."
cd /opt/mediastack
docker compose up -d

echo ">>> ✅ Installation terminée !"
echo "Accède à l’interface via : http://<IP_DU_LXC>/"
