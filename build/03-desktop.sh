#!/usr/bin/sh
set -ouex pipefail

### Install programs
dnf5 install -y \
    glycin-gtk4-libs \
    glycin-libs \
    glycin-loaders \
    glycin-thumbnailer \
    helix \
    kde-connect \
    pinta \
    podman \
    podman-compose \
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
    vlc-plugins-video-out

dnf5 install -y --allowerasing \
    steam \

# Install netbird
sh /ctx/build/scripts/install-netbird.sh

# Install dcal
# sh /ctx/build/scripts/install-dcal.sh
dnf5 -y copr enable duxlabs/dux-repo
dnf5 -y install dux-calendar
dnf5 -y copr disable duxlabs/dux-repo

# Install Gnome Apps
dnf5 install -y \
    gnome-logs \
    gnome-calculator \
    gnome-calendar \
    gnome-characters \
    gnome-clocks \
    gnome-firmware \
    gnome-font-viewer \
    gnome-keyring \
    gnome-text-editor \
    meld \
    baobab \
    loupe \
    seahorse

dnf5 remove -y \
    gnome-software

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
sh /ctx/build/scripts/install-vscode.sh

# Install rust
sh /ctx/build/scripts/install-rust.sh


### Install Yubikey tools
dnf5 install -y \
    libfido2-devel \
    pam-u2f \
    pamu2fcfg \
    ykpers \
    yubikey-manager \
    yubikey-manager-qt

