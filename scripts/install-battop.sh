#!/usr/bin/env bash
set -euo pipefail


echo ">>> Fetching latest battop release..."
# Get latest x86_64 asset URL for battop
LATEST_URL=$(
  curl -s https://api.github.com/repos/svartalf/rust-battop/releases/latest \
    | jq -r '.assets[]
             | select(.name | contains("x86_64")
                               and endswith("linux-gnu"))
             | .browser_download_url'
)

if [[ -z "$LATEST_URL" ]]; then
    echo ">>> ERROR: Could not find x86_64 release asset for battop." >&2
    exit 1
fi

echo ">>> Downloading battop: $LATEST_URL..."

# Download bin
curl -L "$LATEST_URL" -o /tmp/battop

echo ">>> Installing battop..."

install -m 0755 /tmp/battop /usr/bin/battop

# Cleanup
rm -rf /tmp/battop

battop -h
echo ">>> battop installed successfully."