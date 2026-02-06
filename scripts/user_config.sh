#!/usr/bin/sh
set -ouex pipefail

### Copy custom dotfiles for user template
rsync -rvK /ctx/dotfiles/ /etc/skel/

### Remove fedora startpage
rm -f /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js

### Enable services
# Enable user service for post install changes
systemctl --global enable post-first-install-changes.service
# Enable user service for syncthing
systemctl --global enable syncthing.service