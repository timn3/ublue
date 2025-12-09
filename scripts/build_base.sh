#!/usr/bin/sh

set -ouex pipefail

### Copy custom services
rsync -rvK /ctx/system_files/ /
install -Dm0644 -t /usr/share/flatpak /ctx/flatpaks/*.txt

# Enable service for automatic flatpak install
systemctl --global enable flatpak-user-install.service

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1


tee /etc/yum.repos.d/netbird.repo<<EOF
[netbird]
name=netbird
baseurl=https://pkgs.netbird.io/yum/
enabled=1
gpgcheck=0
gpgkey=https://pkgs.netbird.io/yum/repodata/repomd.xml.key
repo_gpgcheck=1
EOF

dnf5 config-manager addrepo --overwrite --from-repofile=/etc/yum.repos.d/netbird.repo
dnf5 install -y --setopt=tsflags=noscripts netbird

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
    gnome-shell-extension-gsconnect \ 
    gnome-shell-extension-user-theme

# this installs a package from fedora repos
dnf5 install -y \
    bat \
    btop \
    fzf \
    zoxide \
    zsh \
    keepassxc \
    syncthing \
    thunderbird

## requires flatpak version 1.17
# if [[ "$(rpm -E %fedora)" -ge "43" ]]; then
#   systemctl enable flatpak-preinstall.service
# fi

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File
# systemctl enable netbird
systemctl enable podman.socket