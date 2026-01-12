#!/usr/bin/env bash
set -euo pipefail

echo ">>> Importing Microsoft GPG key..."
rpm --import https://packages.microsoft.com/keys/microsoft.asc

echo ">>> Writing /etc/yum.repos.d/vscode.repo..."
cat >/etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

echo ">>> Refreshing package metadata..."
dnf check-update || true   # non-zero exit if no updates, so ignore

echo ">>> Installing Visual Studio Code..."
dnf install -y code   # or: code-insiders

echo ">>> VS Code installation completed."