#!/usr/bin/sh
set -ouex pipefail

### Build and install Mango-Ext
dnf5 install -y --skip-unavailable \
	wayland-devel \
	wayland-protocols-devel  \
	libinput-devel \
	libdrm-devel \
	libxkbcommon-devel \
	pixman-devel \
	libdisplay-info-devel \
	hwdata-devel \
	seatd \
	libseat-devel \
	pcre2-devel \
	xorg-x11-server-Xwayland-devel \
	libxcb-devel \
	gcc \
	gcc-c++ \
	xcb-util-wm-devel \
	cmake \
	meson \
	ninja-build \
	pkgconf-pkg-config \
	mesa-libGLES-devel \
	mesa-libEGL-devel \
	libglvnd-devel \
	libliftoff-devel \
	mesa-libgbm-devel \
	systemd-devel \
	cjson-devel \
	pango-devel \
	pango

mkdir -p /tmp/dev
cd /tmp/dev

git clone -b 0.20.2 https://gitlab.freedesktop.org/wlroots/wlroots.git
cd /tmp/dev/wlroots
rm -rf build
meson setup build --prefix=/usr --libdir=lib64 -Drenderers=gles2
meson build -Dprefix=/usr
ninja -C build install

cd /tmp/dev
git clone -b 0.4.1 https://github.com/wlrfx/scenefx.git
cd /tmp/dev/scenefx
rm -rf build
meson setup build --prefix=/usr --libdir=lib64
meson build -Dprefix=/usr
ninja -C build install

cd /tmp/dev
# git clone https://github.com/mangowm/mango.git
git clone https://github.com/ernestoCruz05/mango-ext.git
# cd /tmp/dev/mango
cd /tmp/dev/mango-ext
rm -rf build
meson setup build --prefix=/usr --libdir=lib64
meson build -Dprefix=/usr
ninja -C build install
