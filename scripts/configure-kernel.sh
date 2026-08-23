#!/usr/bin/env bash
# Load kernel modules required by WireGuard
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

info "Loading kernel modules for WireGuard..."

sudo modprobe iptable_nat
sudo modprobe ip6table_nat

grep -q "iptable_nat" /etc/modules || echo "iptable_nat" | sudo tee -a /etc/modules >/dev/null
grep -q "ip6table_nat" /etc/modules || echo "ip6table_nat" | sudo tee -a /etc/modules >/dev/null

info "Kernel modules configured."
