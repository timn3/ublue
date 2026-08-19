#!/usr/bin/env bash
set -euo pipefail


echo ">>> Fetching latest zellij release..."
# Get latest x86_64 asset URL for zellij
LATEST_URL=$(
  curl -s https://api.github.com/repos/zellij-org/zellij/releases/latest \
    | jq -r '.assets[]
             | select(.name | contains("zellij-no-web-x86_64-unknown-linux-musl.tar.gz"))
             | .browser_download_url'
)

if [[ -z "$LATEST_URL" ]]; then
    echo ">>> ERROR: Could not find x86_64 release asset for zellij." >&2
    exit 1
fi

echo ">>> Downloading zellij: $LATEST_URL..."

# Download tarball
curl -L "$LATEST_URL" -o /tmp/zellij.tar.gz

# Extract
mkdir -p /tmp/zellij_extract
tar -xzf /tmp/zellij.tar.gz -C /tmp/zellij_extract

# Find the 'zellij' binary inside the tarball
ZELLIJ_BIN=$(find /tmp/zellij_extract -type f -name zellij | head -n 1)

if [[ -z "$ZELLIJ_BIN" ]]; then
    echo ">>> ERROR: 'zellij' binary not found in extracted archive." >&2
    exit 1
fi

echo ">>> Installing zellij from: $ZELLIJ_BIN..."

install -m 0755 "$ZELLIJ_BIN" /usr/bin/zellij

# Cleanup
rm -rf /tmp/zellij.tar.gz /tmp/zellij_extract

zellij --version
echo ">>> zellij installed successfully."
