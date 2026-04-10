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

### Allow GSConnect to connect through firewall
firewall-cmd --permanent --zone=public --add-service=kdeconnect

### ensure the netbird service is started after install
netbird service install || true
netbird service start || true

### Configure Gnome Keybindings
## TODO add check if gnome is used
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"

mkdir -p "$(dirname "$HASH_FILE")"
touch "$HASH_FILE"
echo "$NEW_HASH" > "$HASH_FILE"