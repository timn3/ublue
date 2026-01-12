#!/usr/bin/sh
set -ouex pipefail

### Copy custom dotfiles for user template
rsync -rvK /ctx/dotfiles/ /etc/skel/

### Configure Gnome Keybindings
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"

### Remove fedora startpage
rm -f /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js

### Enable services
# Enable automatic update user service
systemctl --global enable bootc-check-update.timer
systemctl --global enable bootc-check-update.service
# Enable user service for post install changes
systemctl --global enable post-first-install-changes.service
# Enable user service for syncthing
systemctl --global enable syncthing.service