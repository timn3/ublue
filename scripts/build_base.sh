#!/usr/bin/sh
set -ouex pipefail

### Copy custom system files
rsync -rvK /ctx/system_files/ /

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

### Install programs
# Install CLI tools
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
    neovim \
    v4l-utils \
    ffmpeg

# Install eza
sh /ctx/scripts/install_scripts/install-eza.sh

# Install starship
dnf5 -y copr enable atim/starship
dnf5 -y install starship
dnf5 -y copr disable atim/starship

### Enable services
# Enable podman socket
systemctl enable podman.socket
# Disable NetworkManager-wait-online for faster (re-)boot
systemctl disable NetworkManager-wait-online.service
# Enable automatic update service
systemctl enable bootc-check-update.timer