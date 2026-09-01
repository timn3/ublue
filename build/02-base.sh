#!/usr/bin/sh
set -ouex pipefail

### Install CLI programs
dnf5 install -y \
    alacritty \
    bat \
    bluetoothctl \
    blueman \
    brightnessctl \
    btop \
    chezmoi \
    distrobox \
    dua-cli \
    fastfetch \
    fd-find \
    ffmpeg \
    foot \
    fuse \
    fuse-libs \
    fzf \
    gcc \
    git-delta \
    htop \
    jq \
    just \
    kanshi \
    libcamera-qcam \
    libcamera-tools \
    lm_sensors \
    make \
    nautilus-python \
    neovim \
    nmtui \
    powerstat \
    powertop \
    procs \
    rg \
    tree-sitter-cli \
    udiskie \
    v4l-utils \
    wofi \
    zoxide \
    zsh

# Install eza
sh /ctx/build/scripts/install-eza.sh

# Install battop
sh /ctx/build/scripts/install-battop.sh

# Install zellij
sh /ctx/build/scripts/install-zellij.sh

# Install vpn
dnf5 -y install \
    openconnect \
    NetworkManager-openconnect 

# Install howdy
dnf5 -y copr enable starfish/howdy-beta
dnf5 -y install howdy
dnf5 -y copr disable starfish/howdy-beta

# Install yazi
dnf5 -y copr enable lihaohong/yazi
dnf5 -y install yazi
dnf5 -y copr disable lihaohong/yazi

# Install starship
dnf5 -y copr enable atim/starship
dnf5 -y install starship
dnf5 -y copr disable atim/starship
