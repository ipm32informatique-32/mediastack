#!/usr/bin/env bash
set -e

PUID=${PUID:-1000}
PGID=${PGID:-1000}
TZ=${TZ:-"Europe/Paris"}
BASE_DIR=${BASE_DIR:-/srv/media-stack}
COMPOSE_FILE=${BASE_DIR}/docker-compose.yml

echo "[*] Déploiement de la stack média dans ${BASE_DIR}"
echo "PUID=${PUID}, PGID=${PGID}, TZ=${TZ}"

# Détection LXC et IP
if command -v pct &>/dev/null; then
  echo "[*] Liste des LXC et IP:"
  pct list
fi

echo "[*] IPs locales:"
hostname -I || true

# Installer dépendances
apt update
apt install -y ca-certificates curl gnupg lsb-release apt-transport-https software-properties-common

# Installer Docker si absent
if ! command -v docker &>/dev/null; then
  echo "[*] Installation de Docker..."
  curl -fsSL https://get.docker.com | sh
else
  echo "[*] Docker déjà installé"
fi

# Installer docker-compose plugin si absent
if ! docker compose version &>/dev/null; then
  echo "[*] Installation du plugin docker compose..."
  apt install -y docker-compose-plugin
fi

# Préparer arborescence
mkdir -p "${BASE_DIR}"
cd "${BASE_DIR}"
mkdir -p config/qbittorrent config/prowlarr config/radarr config/sonarr config/bazarr config/jellyfin config/organizr
mkdir -p downloads incomplete media/movies media/tv cache/jellyfin

# Ecrire docker-compose.yml si absent
if [ ! -f "${COMPOSE_FILE}" ]; then
  cat > "${COMPOSE_FILE}" <<'EOF'
version: "3.9"
services:
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Paris
      - WEBUI_PORT=8080
    volumes:
      - ./config/qbittorrent:/config
      - ./downloads:/downloads
      - ./incomplete:/incomplete
    ports:
      - "8080:8080"
      - "6881:6881"
      - "6881:6881/udp"
    restart: unless-stopped

  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Paris
    volumes:
      - ./config/prowlarr:/config
    ports:
      - "9696:9696"
    restart: unless-stopped

  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Paris
    volumes:
      - ./config/radarr:/config
      - ./downloads:/downloads
      - ./media/movies:/movies
    ports:
      - "7878:7878"
    restart: unless-stopped

  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Paris
    volumes:
      - ./config/sonarr:/config
      - ./downloads:/downloads
      - ./media/tv:/tv
    ports:
      - "8989:8989"
    restart: unless-stopped

  bazarr:
    image: lscr.io/linuxserver/bazarr:latest
    container_name: bazarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Paris
    volumes:
      - ./config/bazarr:/config
      - ./media/movies:/movies
      - ./media/tv:/tv
      - ./downloads:/downloads
    ports:
      - "6767:6767"
    restart: unless-stopped

  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Paris
    volumes:
      - ./config/jellyfin:/config
      - ./media:/media
      - ./cache/jellyfin:/cache
    ports:
      - "8096:8096"
    restart: unless-stopped

  organizr:
    image: lscr.io/linuxserver/organizr:latest
    container_name: organizr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Paris
    volumes:
      - ./config/organizr:/config
    ports:
      - "80:80"
    restart: unless-stopped

networks:
  default:
    name: media-stack

EOF
fi

# Droits
chown -R ${PUID}:${PGID} "${BASE_DIR}"

# Lancement
docker compose -f "${COMPOSE_FILE}" pull
docker compose -f "${COMPOSE_FILE}" up -d

echo "[*] Déploiement terminé. Accès via Organizr: http://$(hostname -I | awk '{print $1}')/"
