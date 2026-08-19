#!/usr/bin/sh
set -ouex pipefail

### Install programs
dnf5 install -y \
    glycin-gtk4-libs \
    glycin-libs \
    glycin-loaders \
    glycin-thumbnailer \
    kde-connect \
    pinta \
    solaar \
    solaar-udev \
    steam \
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
    vlc-plugins-video-out

# Install netbird
sh /ctx/build/scripts/install-netbird.sh

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
    meld \
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
rm /etc/yum.repos.d/google-chrome.repo


# Install vs code
# sh /ctx/build/scripts/install-vscode.sh


### Install Yubikey tools
dnf5 install -y \
    libfido2-devel \
    pam-u2f \
    pamu2fcfg \
    ykpers \
    yubikey-manager \
    yubikey-manager-qt

# Install howdy
# TODO Solve dependency issues
# sh /ctx/scripts/install_scripts/install-howdy.sh


# Install super prod
# sh /ctx/scripts/install_scripts/install-superprod.sh

