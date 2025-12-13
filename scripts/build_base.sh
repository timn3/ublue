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

# Install codecs
dnf5 -y install \
        rpmfusion-free-release \
        rpmfusion-nonfree-release \
        intel-media-driver libva-intel-driver \
        gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-ugly gstreamer1-vaapi

# Install Gnome Apps
dnf5 install -y --skip-unavailable \
    gnome-logs \
    gnome-calculator \
    gnome-calendar \
    gnome-characters \
    gnome-clocks \
    gnome-firmware \
    gnome-font-viewer \
    gnome-text-editor \
    baobab 

# Install Gnome Extensions
dnf5 install -y --skip-unavailable \
    gnome-shell-extension-appindicator \
    gnome-shell-extension-caffeine \
    gnome-shell-extension-gsconnect 

# this installs a package from fedora repos
dnf5 install -y \
    bat \
    btop \
    fastfetch \
    fd \
    fzf \
    lm_sensors \
    rg \
    zoxide \
    zsh \
    keepassxc \
    syncthing \
    thunderbird 

dnf5 -y copr enable atim/starship
dnf5 -y install starship
dnf5 -y copr disable atim/starship


### TODO handle python dependency
# dnf5 -y copr enable principis/howdy
# dnf5 -y install howdy
# dnf5 -y copr disable principis/howdy


# Install netbird
sh /ctx/scripts/install-netbird.sh

# Install eza
sh /ctx/scripts/install-eza.sh

# Install vs code
sh /ctx/scripts/install-vscode.sh

## requires flatpak version 1.17
# if [[ "$(rpm -E %fedora)" -ge "43" ]]; then
#   systemctl enable flatpak-preinstall.service
# fi

#### Example for enabling a System Unit File
# systemctl enable netbird # fails TODO start as user?
systemctl enable podman.socket