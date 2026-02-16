#!/usr/bin/sh
set -ouex pipefail

### Install programs
dnf5 install -y \
    keepassxc \
    solaar \
    solaar-udev \
    syncthing \
    thunderbird \
    vlc \
    vlc-cli \
    vlc-gui-qt \
    vlc-gui-skins2 \
    vlc-libs \
    vlc-plugin-ffmpeg \
    vlc-plugin-gnome \
    vlc-plugin-lua \
    vlc-plugin-notify \
    vlc-plugin-pipewire \
    vlc-plugin-pulseaudio \
    vlc-plugin-visualization \
    vlc-plugins-base \
    vlc-plugins-extra \
    vlc-plugins-freeworld \
    vlc-plugins-video-out \
    glycin-gtk4-libs \
    glycin-loaders \
    glycin-libs \
    glycin-thumbnailer  

# Install Gnome Apps
dnf5 install -y \
    gnome-logs \
    gnome-calculator \
    gnome-calendar \
    gnome-characters \
    gnome-clocks \
    gnome-firmware \
    gnome-font-viewer \
    gnome-text-editor \
    baobab \
    loupe

# Install Gnome Extensions
dnf5 install -y \
    gnome-shell-extension-appindicator \
    gnome-shell-extension-caffeine \
    gnome-shell-extension-gsconnect 

dnf5 -y copr enable wojnilowicz/ungoogled-chromium 
dnf5 -y install ungoogled-chromium
dnf5 -y copr disable wojnilowicz/ungoogled-chromium 

### TODO handle python dependency
# dnf5 -y copr enable principis/howdy-beta
# dnf5 -y install howdy
# dnf5 -y copr disable principis/howdy-beta

# Install battop
sh /ctx/scripts/install_scripts/install-battop.sh

# Install netbird
sh /ctx/scripts/install_scripts/install-netbird.sh

# Install howdy
# TODO Solve dependency issues
# sh /ctx/scripts/install_scripts/install-howdy.sh

# Install vs code
sh /ctx/scripts/install_scripts/install-vscode.sh

### Install flatpaks
# Add flatpak list
install -Dm0644 -t /usr/share/flatpak /ctx/flatpaks/*.txt

# Enable service for automatic flatpak install
systemctl --global enable flatpak-user-install.service

## TODO Switch to flatpak-preinstall when available
# if [[ "$(rpm -E %fedora)" -ge "44" || "$(flatpak --version | awk '{ print $2 }' | awk -F . '{ print $2 }')" -ge "17" ]]; then
#   systemctl enable flatpak-preinstall.service
# fi