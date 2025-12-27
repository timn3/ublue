#!/usr/bin/env bash
set -euo pipefail

echo ">>> Fetching latest howdy release..."
# Get code from howdy repo
GIT_URL="https://github.com/boltgolt/howdy.git"


# Install dependencies
dnf5 -y group install --skip-unavailable development-tools development-libraries
dnf5 -y install --skip-unavailable \
    meson ninja-build gcc-c++ \
    python3 python3-pip python3-setuptools python3-wheel \
    cmake make \
    pam-devel inih-devel libevdev-devel python3-opencv \
    python3-devel opencv-devel python3-dlib

# Download tarball
git clone "$GIT_URL" /tmp/howdy

echo ">>> Installing howdy from: $GIT_URL..."

meson setup /tmp/howdy/build /tmp/howdy
meson compile -C /tmp/howdy/build
meson install -C /tmp/howdy/build

# Cleanup
rm -rf /tmp/howdy
dnf5 -y group remove development-tools development-libraries
dnf5 -y remove \
    meson ninja-build gcc-c++ \
    python3 python3-pip python3-setuptools python3-wheel \
    cmake make \
    pam-devel inih-devel libevdev-devel python3-opencv \
    python3-devel opencv-devel python3-dlib


# howdy version
echo ">>> howdy installed successfully."