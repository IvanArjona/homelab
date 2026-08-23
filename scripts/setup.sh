#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────────
# Homelab server setup (Ubuntu)
# Run as your regular user — the script uses sudo where needed.
# Safe to run multiple times (idempotent).
# ──────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/common.sh"

info "Starting homelab setup..."

source "$SCRIPT_DIR/install-docker.sh"
source "$SCRIPT_DIR/configure-dns.sh"
source "$SCRIPT_DIR/configure-kernel.sh"
source "$SCRIPT_DIR/create-directories.sh"

info "Setup complete!"
