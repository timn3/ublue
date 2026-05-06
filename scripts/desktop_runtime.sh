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
    waybar \
    swaybg \
    swayidle \
    swaylock \
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
    kde-connect

# dnf5 -y copr enable lionheartp/Hyprland 
# dnf5 -y install noctalia-shell-v5
# dnf5 -y copr disable lionheartp/Hyprland 

# Install starship
dnf5 -y copr enable atim/starship
dnf5 -y install starship
dnf5 -y copr disable atim/starship

### Enable services
# Disable NetworkManager-wait-online for faster (re-)boot
systemctl disable NetworkManager-wait-online.service
# Enable automatic update service
systemctl enable bootc-check-update.timer