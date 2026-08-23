#!/usr/bin/env bash
# Install Docker and configure it for the current user
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# ──────────────────────────────────────────────────────────────────────────────
# Install Docker engine
# ──────────────────────────────────────────────────────────────────────────────

if ! command -v docker &>/dev/null; then
  info "Installing Docker..."

  sudo apt-get update -qq
  sudo apt-get install -y -qq ca-certificates curl

  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -qq
  sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
  info "Docker already installed, skipping."
fi

# ──────────────────────────────────────────────────────────────────────────────
# Docker group & boot
# ──────────────────────────────────────────────────────────────────────────────

if ! groups "$USER" | grep -q '\bdocker\b'; then
  info "Adding $USER to docker group..."
  sudo groupadd -f docker
  sudo usermod -aG docker "$USER"
  warn "Log out and back in for docker group membership to take effect."
else
  info "User $USER already in docker group."
fi

sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service

info "Docker setup done."
