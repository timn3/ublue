#!/usr/bin/env bash
set -euo pipefail


echo ">>> Fetching latest eza release..."
# Get latest x86_64 asset URL for eza
LATEST_URL=$(
  curl -s https://api.github.com/repos/eza-community/eza/releases/latest \
    | jq -r '.assets[]
             | select(.name | contains("x86_64")
                               and contains("linux-gnu")
                               and endswith(".tar.gz"))
             | .browser_download_url'
)

if [[ -z "$LATEST_URL" ]]; then
    echo ">>> ERROR: Could not find x86_64 release asset for eza." >&2
    exit 1
fi

echo ">>> Downloading eza: $LATEST_URL..."

# Download tarball
curl -L "$LATEST_URL" -o /tmp/eza.tar.gz

# Extract
mkdir -p /tmp/eza_extract
tar -xzf /tmp/eza.tar.gz -C /tmp/eza_extract

# Find the 'eza' binary inside the tarball
EZA_BIN=$(find /tmp/eza_extract -type f -name eza | head -n 1)

if [[ -z "$EZA_BIN" ]]; then
    echo ">>> ERROR: 'eza' binary not found in extracted archive." >&2
    exit 1
fi

echo ">>> Installing eza from: $EZA_BIN..."

install -m 0755 "$EZA_BIN" /usr/bin/eza

# Cleanup
rm -rf /tmp/eza.tar.gz /tmp/eza_extract

eza --version
echo ">>> eza installed successfully."
