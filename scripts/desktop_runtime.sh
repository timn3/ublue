#!/usr/bin/sh
set -ouex pipefail

### Install programs
# Install CLI tools

dnf5 install -y \
    bat \
    btop \
    distrobox \
    fastfetch \
    fd-find \
    gcc \
    git-delta \
    make \
    tree-sitter-cli \
    fuse \
    fzf \
    htop \
    lm_sensors \
    jq \
    nautilus-python \
    rg \
    zoxide \
    zsh \
    neovim \
    procs \
    dua-cli \
    v4l-utils \
    ffmpeg

# Install eza
sh /ctx/scripts/install_scripts/install-eza.sh

# Install cosign
sh /ctx/scripts/install_scripts/install-cosign.sh

### Install Yubikey tools
dnf5 install -y \
    libfido2-devel \
    pam-u2f \
    pamu2fcfg \
    ykpers \
    yubikey-manager \
    yubikey-manager-qt

# auto mount:
# dnf5 -y install udiskie

# comand line file manager test:
dnf5 -y copr enable lihaohong/yazi
dnf5 -y install yazi
# dnf5 -y install nnn
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