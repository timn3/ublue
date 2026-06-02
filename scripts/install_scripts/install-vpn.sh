#!/usr/bin/env bash
set -euo pipefail

rm /opt
mkdir /opt

# Make opt persistent across reboots
systemctl enable ostree-state-overlay@opt.service --now

# Install Cisco Secure Client VPN
dnf5 -y install /ctx/binaries/cisco-secure-client-vpn-5.1.17.3382-1.x86_64.rpm


echo ">>> Cisco Secure Client VPN installed successfully."
