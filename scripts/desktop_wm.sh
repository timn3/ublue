#!/usr/bin/sh
set -ouex pipefail

dnf5 install -y \
    wofi \
    nmtui \
    kanshi \
    kde-connect \
    qs \
    noctalia-shell \
	brightnessctl \
	bluetoothctl

dnf5 install -y \
    xdg-desktop-portal \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-wlr

dnf5 -y copr enable lionheartp/Hyprland 
# dnf5 -y install noctalia-shell-v5
dnf5 -y install \
    hyprcursor \
    hyprgraphics \
    hyprland \
    hyprlock \
    hypridle \
    hyprland-plugins \
    hyprland-protocols \
    hyprlang \
    hyprlauncher \
    hyprpaper \
    hyprpicker \
    hyprpolkitagent \
    hyprpwcenter \
    hyprshot \
    hyprshutdown \
    hyprsunset \
    hyprsysteminfo \
    hyprutils \
    hyprwayland-scanner
dnf5 -y copr disable lionheartp/Hyprland 

# Top bar test
dnf5 -y copr enable killcrb/ashell
dnf5 -y install ashell
dnf5 -y copr disable killcrb/ashell

# Launcher test:
dnf5 -y copr enable quadratech188/vicinae
dnf5 -y install vicinae
dnf5 -y copr disable quadratech188/vicinae