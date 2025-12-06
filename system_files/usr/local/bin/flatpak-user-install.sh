#!/usr/bin/env bash
set -euo pipefail

LIST_FILE="/usr/share/flatpak/flatpaks.txt"
RUN_MARKER="$HOME/.local/share/flatpak/.bootc-flatpak-installed"

# If we've already run once, exit
if [[ -f "$RUN_MARKER" ]]; then
    exit 0
fi

# Ensure Flathub exists
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install each Flatpak
while IFS= read -r app || [[ -n "$app" ]]; do
    [[ -z "$app" ]] && continue
    flatpak install --or-update -y --user flathub "$app"
done < "$LIST_FILE"


mkdir -p "$(dirname "$RUN_MARKER")"
touch "$RUN_MARKER"
