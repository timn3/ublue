#!/usr/bin/sh
set -ouex pipefail

### Install flatpaks
## Switch to flatpak-preinstall when available
if [[ "$(rpm -E %fedora)" -ge "44" || "$(flatpak --version | awk '{ print $2 }' | awk -F . '{ print $2 }')" -ge "17" ]]; then
    flatpak preinstall --assumeyes --noninteractive /ctx/flatpaks/*.preinstall
else 
    echo "Flatpak preinstall is not available on this system. Please install the flatpaks manually."
    exit 1
fi