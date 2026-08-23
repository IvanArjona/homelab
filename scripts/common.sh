#!/usr/bin/env bash
# Shared helpers for setup scripts

set -euo pipefail

info()  { echo -e "\033[1;34m:: $*\033[0m"; }
warn()  { echo -e "\033[1;33m⚠  $*\033[0m"; }
error() { echo -e "\033[1;31m✗  $*\033[0m" >&2; exit 1; }

# Resolve paths relative to the project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load required env vars
ENV_FILE="$PROJECT_DIR/.env"
[[ -f "$ENV_FILE" ]] || error ".env file not found. Run: cp .env.example .env"

env_get() {
  grep -m1 "^${1}=" "$ENV_FILE" | cut -d= -f2
}

PUID=$(env_get PUID)
GUID=$(env_get GUID)

[[ -n "$PUID" ]] || error "PUID is not set in .env"
[[ -n "$GUID" ]] || error "GUID is not set in .env"
