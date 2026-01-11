#!/usr/bin/sh

set -ouex pipefail

### Copy custom system files
rsync -rvK /ctx/system_files/ /

### Copy custom dotfiles for user template
rsync -rvK /ctx/dotfiles/ /etc/skel/

### Install flatpaks
# Add flatpak list
install -Dm0644 -t /usr/share/flatpak /ctx/flatpaks/*.txt

# Enable service for automatic flatpak install
systemctl --global enable flatpak-user-install.service

### Install packages
# Activate non-free rpmfusion repos
dnf5 -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

### Add Terra
dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

### Install codecs
dnf5 -y install \
        rpmfusion-free-release \
        rpmfusion-nonfree-release

### Media codecs
dnf5 -y group install multimedia
dnf5 -y swap 'ffmpeg-free' 'ffmpeg' --allowerasing # Switch to full FFMPEG.
dnf5 -y upgrade @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin # Installs gstreamer components. Required if you use Gnome Videos and other dependent applications.
dnf5 -y group install -y sound-and-video # Installs useful Sound and Video complementary packages.

### HW Accelerattion
dnf5 -y install ffmpeg-libs libva libva-utils
## Intel
dnf5 -y swap libva-intel-media-driver intel-media-driver --allowerasing
dnf5 -y install libva-intel-driver \
        gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-ugly gstreamer1-vaapi
## AMD
# dnf -y swap mesa-va-drivers mesa-va-drivers-freeworld
# dnf -y swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
# dnf -y swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
# dnf -y swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686

dnf5 install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264
dnf5 config-manager setopt fedora-cisco-openh264.enabled=1

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

# this installs a package from fedora repos
dnf5 install -y \
    bat \
    btop \
    fastfetch \
    fd \
    fuse \
    fzf \
    htop \
    lm_sensors \
    nautilus-python \
    rg \
    zoxide \
    zsh \
    keepassxc \
    neovim \
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

dnf5 -y copr enable atim/starship
dnf5 -y install starship
dnf5 -y copr disable atim/starship

dnf5 -y copr enable wojnilowicz/ungoogled-chromium 
dnf5 -y install ungoogled-chromium
dnf5 -y copr disable wojnilowicz/ungoogled-chromium 

### TODO handle python dependency
# dnf5 -y copr enable principis/howdy-beta
# dnf5 -y install howdy
# dnf5 -y copr disable principis/howdy-beta


# Install battop
sh /ctx/scripts/install-battop.sh

# Install netbird
sh /ctx/scripts/install-netbird.sh

# Install eza
sh /ctx/scripts/install-eza.sh

# Install howdy
# TODO Solve dependency issues
# sh /ctx/scripts/install-howdy.sh

# Install vs code
sh /ctx/scripts/install-vscode.sh

### Remove fedora startpage
rm -f /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js

## requires flatpak version 1.17
# if [[ "$(rpm -E %fedora)" -ge "43" ]]; then
#   systemctl enable flatpak-preinstall.service
# fi

#### Example for enabling a System Unit File
# Enable automatic update service
systemctl enable bootc-check-update.timer
systemctl enable bootc-check-update.service
# systemctl enable netbird # fails TODO start as user?
systemctl enable podman.socket
# Enable user service for post install changes
systemctl --global enable post-first-install-changes.service
# Enable user service for syncthing
systemctl --global enable syncthing.service
# Disable NetworkManager-wait-online for faster (re-)boot
systemctl disable NetworkManager-wait-online.service