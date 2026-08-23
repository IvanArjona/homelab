#!/usr/bin/env bash
# Free up port 53 for Pi-hole by disabling systemd-resolved stub listener
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

if grep -q '^#\?DNSStubListener=yes' /etc/systemd/resolved.conf 2>/dev/null; then
  info "Disabling systemd-resolved DNS stub listener..."
  sudo sed -i 's/^\#\?DNSStubListener=yes$/DNSStubListener=no/' /etc/systemd/resolved.conf
  sudo systemctl restart systemd-resolved
else
  info "DNS stub listener already disabled."
fi

info "DNS configuration done."
