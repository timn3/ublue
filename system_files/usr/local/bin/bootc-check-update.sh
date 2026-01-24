#!/usr/bin/env bash
set -euo pipefail


if sudo bootc upgrade --check | awk '{ $1$2 == "Nochanges"}'; then
    echo "Exit"
    exit 0
fi

notify-send \
 --app-name="bootc-check-update" \
 --urgency=normal \
 --icon="/etc/ublue/fedora.png" \
 --category="system" \
 "System Update Ready" \
 "A system update has been is available. Run 'sudo bootc upgrade' to apply it."