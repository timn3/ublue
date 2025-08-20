#!/bin/bash

set -ouex pipefail

### Install packages

# hardware/drivers
dnf5 install -y \
    kernel-modules-extra \
    iwlwifi-mvm-firmware \
    alsa-sof-firmware \
    NetworkManager-wifi \
    NetworkManager-openvpn-gnome \
    powertop \
    wpa_supplicant

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

# shell tools and development
dnf install -y --skip-unavailable \
    cockpit-system \
    cockpit-ws \
    cyrus-sasl-plain \
    fpaste \
    git \
    glibc-langpack-de \
    glibc-langpack-en \
    isync \
    krb5-workstation \
    man-db \
    mtr \
    mutt  \
    neovim \
    nmap-ncat \
    restic \
    rsync \
    strace \
    syncthing \
    systemd-container \
    toolbox \
    tree \
    w3m \
    wget \ 
    # btop \
    code

# desktop plumbing/apps
dnf install -y \
    dejavu-sans-fonts \
    dejavu-serif-fonts \
    dejavu-sans-mono-fonts \
    flatpak \
    fontawesome-fonts \
    google-noto-emoji-color-fonts \
    gvfs-mtp \
    pulseaudio-utils \
    alsa-plugins-pulseaudio \
    gstreamer1-plugins-good \
    gstreamer1-plugins-bad-free \
    gstreamer1-plugin-openh264 \
    gstreamer1-libav \
    libavdevice \
    xdg-desktop-portal-gtk \
    pavucontrol \
    pcmanfm \
    nm-connection-editor \
    eog \
    evince \
    rhythmbox \
    gnome-keyring \
    pinentry-gnome3 \
    mate-polkit \
    lxterminal \
    gnome-disk-utility \
    rofimoji

# sway/wayland desktop
dnf install -y \
    sway \
    swayidle \
    swaylock \
    kanshi \
    mako \
    waybar \
    slurp \
    grim \
    xorg-x11-server-Xwayland \
    firefox \
    wofi \
    brightnessctl \
    wl-clipboard

dnf remove -y \
    NetworkManager-cloud-setup \
    adcli \
    avahi \
    btrfs-progs \
    chrony \
    cloud-utils-growpart \
    fwupd \
    libosinfo \
    lvm2 \
    lvm2-libs \
    nfs-utils \
    nilfs-utils \
    passim-libs \
    quota-nls \
    rpcbind \
    sssd-common \
    sssd-nfs-idmap \
    sos \
    tracker \
    tracker-miners \
    udftools \
    vim-data \
    vim-minimal \
    xdg-desktop-portal-wlr \
    zram-generator

rpm -qa 'qemu-user-static*' | xargs dnf remove -y

dnf clean all

rpm -e --verbose dnf dnf-data python3-dnf

# Default terminal tools
# dnf5 install -y zsh ptyxis


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
