#!/usr/bin/env bash
set -euo pipefail


echo ">>> Fetching latest bitwarden release..."
curl -L "https://bitwarden.com/download/?app=desktop&platform=linux&variant=rpm" -o /tmp/bitwarden.rpm

# install the rpm package
dnf install -y /tmp/bitwarden.rpm

# Cleanup
rm -rf /tmp/bitwarden*


echo ">>> bitwarden installed successfully."
