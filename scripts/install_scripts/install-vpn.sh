#!/usr/bin/env bash
set -euo pipefail

# Some ostree/bootc images have /opt -> /var/opt.
if [[ -L /opt ]]; then
    mkdir -p "$(readlink -m /opt)"
else
    mkdir -p /opt
fi


dnf5 -y install /ctx/binaries/cisco-secure-client-vpn-5.1.17.3382-1.x86_64.rpm

echo ">>> Cisco Secure Client VPN installed successfully."
