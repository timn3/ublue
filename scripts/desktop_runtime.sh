#!/usr/bin/sh
set -ouex pipefail

### Install programs
# Install CLI tools
dnf5 install -y \
    bat \
    btop \
    distrobox \
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
    neovim \
    v4l-utils \
    ffmpeg

# Install eza
sh /ctx/scripts/install_scripts/install-eza.sh

# Install cosign
sh /ctx/scripts/install_scripts/install-cosign.sh

### Install sway
dnf5 -y install \
    sway \
    wofi \
    grim \
    slurp \
    nm-applet \
    tuned-switcher \
    wlroots \
    nmtui \
    brightnessctl \
    bluetoothctl \
    xdg-desktop-portal-wlr \
    xdg-desktop-portal-gtk \
    wmenu \
    foot \
    kitty \
    jq \
    kanshi \
    qs \
    noctalia-shell \
    kde-connect \
    kf6-kitemmodels \
    layer-shell-qt \
    libfido2-devel

dnf5 -y copr enable lionheartp/Hyprland 
# dnf5 -y install noctalia-shell-v5
dnf5 -y install hyprlock hypridle
dnf5 -y copr disable lionheartp/Hyprland 

# sh /ctx/scripts/install_scripts/install-dwl.sh

# Launcher test:
dnf5 -y copr enable quadratech188/vicinae
dnf5 -y install vicinae
dnf5 -y copr disable quadratech188/vicinae

# auto mount:
# dnf5 -y install udiskie

# comand line file manager test:
dnf5 -y copr enable lihaohong/yazi
dnf5 -y install yazi
dnf5 -y install nnn
dnf5 -y copr disable lihaohong/yazi

# Install starship
dnf5 -y copr enable atim/starship
dnf5 -y install starship
dnf5 -y copr disable atim/starship

### Enable services
# Disable NetworkManager-wait-online for faster (re-)boot
systemctl disable NetworkManager-wait-online.service
# Enable automatic update service
systemctl enable bootc-check-update.timer