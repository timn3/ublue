#!/usr/bin/env bash
set -euo pipefail

dnf5 -y install libXScrnSaver

# Some ostree/bootc images have /opt -> /var/opt.
# If /opt is a symlink and /var/opt does not exist, RPM unpacking can fail.
if [[ -L /opt ]]; then
    mkdir -p "$(readlink -m /opt)"
else
    mkdir -p /opt
fi

echo ">>> Fetching latest super-productivity release..."
# Get latest x86_64 asset URL for super-productivity
LATEST_URL=$(
  curl -s https://api.github.com/repos/super-productivity/super-productivity/releases/latest \
    | jq -r '.assets[]
             | select(.name | contains("superProductivity-x86_64.rpm"))
             | .browser_download_url'
)

if [[ -z "$LATEST_URL" ]]; then
    echo ">>> ERROR: Could not find x86_64 release asset for super-productivity." >&2
    exit 1
fi

echo ">>> Downloading super-productivity: $LATEST_URL..."

# Download rpm
curl -L "$LATEST_URL" -o /tmp/super-productivity.rpm

rm -rf "/opt/Super Productivity"; \
dnf5 -y install /tmp/super-productivity.rpm

# Cleanup
rm -rf /tmp/super-productivity.rpm

echo ">>> super-productivity installed successfully."
