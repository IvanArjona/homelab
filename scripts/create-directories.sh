#!/usr/bin/env bash
# Create the /data directory structure with correct ownership
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

info "Creating data directories..."

sudo mkdir -p /data
sudo chown "${PUID}:${GUID}" /data

sudo -u "#${PUID}" mkdir -p \
  /data/torrents/movies \
  /data/torrents/tv \
  /data/media/movies \
  /data/media/tv

info "Data directories ready."
