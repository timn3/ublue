#!/usr/bin/env bash
set -euo pipefail

FILE_TO_HASH="/usr/local/bin/post-first-install-changes.sh"
HASH_FILE="$HOME/.local/share/ublue/.bootc-post-first-install"
if [[ -f "$HASH_FILE" ]]; then
    OLD_HASH=$(cat "$HASH_FILE")
else
    OLD_HASH="N/A"
fi
NEW_HASH=$(sha256sum "$FILE_TO_HASH" | awk '{print $1}')


if [[ "$OLD_HASH" == "$NEW_HASH" ]]; then
    echo "Post boot changes already applied."
    exit 0
fi

### Activate GSConnect
firewall-cmd --permanent --zone=public --add-service=kdeconnect

mkdir -p "$(dirname "$HASH_FILE")"
touch "$HASH_FILE"
echo "$NEW_HASH" > "$HASH_FILE"