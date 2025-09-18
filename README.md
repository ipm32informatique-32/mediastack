# mediastack
qBittorrent, Prowlarr, Radarr, Sonarr, Bazarr, Jellyfin et un dashboard (Organizr)
📚 README — Media Stack Autodeploy 🎬🍿

Bienvenue dans Media Stack Autodeploy :
Une stack tout-en-un pour gérer, télécharger, organiser et streamer tes médias, le tout depuis un seul endroit 🖥️✨

🌟 Contenu de la stack

🎥 Radarr → Gestion automatique de tes films (ajout, suivi, téléchargement).

📺 Sonarr → Gestion de tes séries TV, recherche et téléchargement automatique.

🔎 Prowlarr → Moteur d’indexeurs, connecté à Radarr & Sonarr.

📥 qBittorrent → Téléchargement rapide et automatisé (BitTorrent).

📝 Bazarr → Téléchargement automatique des sous-titres dans toutes les langues.

🎶 Jellyfin → Streaming de tes médias, partout, sur tous tes devices.

🖥️ Organizr → Interface d’accueil centrale qui regroupe tous tes services.

🚀 Déploiement automatique


Ton stack est packagée dans :

docker-compose.yml → Définit tous les conteneurs et leurs volumes.

deploy.sh → Script magique d’installation et de lancement.

🛠️ Installation
unzip media_stack_autodeploy.zip -d /root/media-stack
cd /root/media-stack

Télécharge et décompresse le zip :
unzip media_stack_autodeploy.zip -d /root/media-stack
cd /root/media-stack

Rends le script exécutable et lance-le :
chmod +x deploy.sh
./deploy.sh

Le script va :

Scanner ton LXC et récupérer l’IP 🕵️‍♂️

Installer Docker + Docker Compose 🐳

Déployer la stack complète en un seul coup ⚡

🌍 Accès aux services

Une fois déployé, rends-toi dans ton navigateur :

👉 Page d’accueil Organizr :
http://<IP_DU_LXC>/

