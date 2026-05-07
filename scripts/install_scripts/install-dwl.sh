#!/bin/bash
set -euo pipefail

dnf5 install -y \
    libinput-devel \
    wayland-devel \
    wlroots-devel \
    libxkbcommon-devel \
	wayland-protocols-devel  \
    libxcb-devel \
    xcb-util-wm-devel \
	# wlroots \
	# libxkbcommon \
	# pkgconf-pkg-config \
	# libxcb \
	# libinput \
	# xcb-util-wm \

cd /ctx/source_files/dwl

make -j $(nproc) install