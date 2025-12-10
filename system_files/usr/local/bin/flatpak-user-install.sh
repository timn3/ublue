#!/usr/bin/env bash
set -euo pipefail

LIST_FILE="/usr/share/flatpak/flatpaks.txt"
HASH_FILE="$HOME/.local/share/flatpak/.bootc-flatpak-installed"
if [[ -f "$HASH_FILE" ]]; then
    OLD_HASH=$(cat "$HASH_FILE")
else
    OLD_HASH="N/A"
fi
NEW_HASH=$(sha256sum "$LIST_FILE" | awk '{print $1}')


if [[ "$OLD_HASH" == "$NEW_HASH" ]]; then
    echo "Flatpaks installed, nothing to do."
    exit 0
fi

echo "Flatpak list changed, re-installing flatpaks."
# Ensure Flathub exists
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak uninstall -y --all
# Install each Flatpak
while IFS= read -r app || [[ -n "$app" ]]; do
    [[ -z "$app" ]] && continue
    flatpak install -y --user flathub "$app"
done < "$LIST_FILE"

mkdir -p "$(dirname "$HASH_FILE")"
touch "$HASH_FILE"
echo "$NEW_HASH" > "$HASH_FILE"