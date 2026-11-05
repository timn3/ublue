#!/usr/bin/env bash
set -euo pipefail

echo ">>> Fetching latest bitwarden release..."
curl -L "https://bitwarden.com/download/?app=desktop&platform=linux&variant=rpm" -o /tmp/bitwarden.rpm

mkdir -p /var/opt

# install the rpm package
dnf install -y /tmp/bitwarden.rpm

# relocate payload into the immutable image
mv /var/opt/Bitwarden /usr/lib/Bitwarden

# recreate /opt/Bitwarden at boot, pointing at the relocated files
echo 'L+ /var/opt/Bitwarden - - - - /usr/lib/Bitwarden' > /usr/lib/tmpfiles.d/bitwarden.conf

# Cleanup
rm -rf /tmp/bitwarden*

echo ">>> bitwarden installed successfully."
