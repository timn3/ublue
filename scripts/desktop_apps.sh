#!/usr/bin/sh
set -ouex pipefail

### Install programs
dnf5 install -y \
    chezmoi \
    fuse-libs \
    keepassxc \
    libcamera-tools \
    libcamera-qcam \
    pinta \
    powertop \
    powerstat \
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

### TODO handle python dependency
# dnf5 -y copr enable principis/howdy-beta
# dnf5 -y install howdy
# dnf5 -y copr disable principis/howdy-beta

### Install flatpaks
## Switch to flatpak-preinstall when available
if [[ "$(rpm -E %fedora)" -ge "44" || "$(flatpak --version | awk '{ print $2 }' | awk -F . '{ print $2 }')" -ge "17" ]]; then

    flatpak preinstall --assumeyes --noninteractive /ctx/flatpaks/*.preinstall
else
    # Add flatpak list
    install -Dm0644 -t /usr/share/flatpak /ctx/flatpaks/*.txt

    # Enable service for automatic flatpak install
    systemctl --global enable flatpak-user-install.service
fi