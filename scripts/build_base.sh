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
    gnome-shell-extension-gsconnect 

# this installs a package from fedora repos
dnf5 install -y \
    bat \
    btop \
    fd \
    fzf \
    rg \
    zoxide \
    zsh \
    keepassxc \
    syncthing \
    thunderbird 

dnf5 copr enable atim/starship
dnf5 install -y starship
dnf5 copr disable atim/starship


# dnf5 copr enable principis/howdy
# dnf5 --refresh install howdy
# dnf5 copr disable principis/howdy

## requires flatpak version 1.17
# if [[ "$(rpm -E %fedora)" -ge "43" ]]; then
#   systemctl enable flatpak-preinstall.service
# fi

#### Example for enabling a System Unit File
# systemctl enable netbird # fails TODO start as user?
systemctl enable podman.socket