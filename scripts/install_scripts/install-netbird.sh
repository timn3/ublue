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


echo ">>> Netbird installation completed."