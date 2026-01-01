#!/usr/bin/env bash
set -euo pipefail

echo ">>> Netbird yum repo..."
tee /etc/yum.repos.d/netbird.repo<<EOF
[netbird]
name=netbird
baseurl=https://pkgs.netbird.io/yum/
enabled=1
gpgcheck=0
gpgkey=https://pkgs.netbird.io/yum/repodata/repomd.xml.key
repo_gpgcheck=1
EOF

dnf5 config-manager addrepo --overwrite --from-repofile=/etc/yum.repos.d/netbird.repo

echo ">>> Installing netbird..."
dnf5 install -y --setopt=tsflags=noscripts netbird netbird-ui

echo ">>> activating netbird services..."

# disable ssh config modification by netbird
mkdir -p /etc/netbird
cat >/etc/netbird/netbird.env <<'EOF'
NB_DISABLE_SSH_CONFIG=true
EOF
rm /etc/ssh/ssh_config.d/99-netbird.conf

# ensure the service is started after install
netbird service install || true
netbird service start || true

echo ">>> Netbird installation completed."