#!/usr/bin/sh
set -ouex pipefail

# got to /etc/yum.repos.d and remove the copr repos
# rm /etc/yum.repos.d/copr:*
rm /etc/yum.repos.d/_copr:*
rm /etc/yum.repos.d/terra.repo

### Remove fedora startpage
rm -f /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js

### Enable services
# Disable NetworkManager-wait-online for faster (re-)boot
systemctl disable NetworkManager-wait-online.service
# Enable automatic update service
systemctl enable bootc-check-update.timer
# Enable syncthing autostart
systemctl enable --global syncthing.service
