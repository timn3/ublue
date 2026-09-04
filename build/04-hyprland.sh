#!/usr/bin/sh
set -ouex pipefail

dnf5 install -y \
    xdg-desktop-portal \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-wlr

dnf5 -y copr enable lionheartp/Hyprland
dnf5 -y install \
<<<<<<< HEAD
    aquamarine \
=======
    aquamarie \
>>>>>>> e8f3f65add041f7d001ce4ae3b0438a9adb4ebe6
    hyprcursor \
    hyprgraphics \
    hyprland \
    hyprland-guiutils \
    hyprlock \
    hypridle \
    hyprland-plugins \
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

# Top bar
dnf5 -y copr enable killcrb/ashell
dnf5 -y install ashell
dnf5 -y copr disable killcrb/ashell

# Launcher
dnf5 -y copr enable quadratech188/vicinae
dnf5 -y install vicinae
dnf5 -y copr disable quadratech188/vicinae

# hyprpm dependencies
dnf5 -y install \
    cmake \
    g++ \
    gcc \
    cpio \
    pkgconfig \
    mesa-libGLES-devel \
    mesa-libEGL-devel \
    glslang-devel
