#!/usr/bin/env bash

set -eoux pipefail

mkdir -p /var/roothome

# echo "::group:: ===Install dnf5==="
# if [ "${FEDORA_MAJOR_VERSION}" -lt 41 ]; then
#     rpm-ostree install --idempotent dnf5 dnf5-plugins
# fi

# echo "::endgroup::"

echo "::group:: Copy Files"

# Copy ISO list for `install-system-flaptaks`
install -Dm0644 -t /etc/ublue-os/ /ctx/flatpaks/*.list

echo "::endgroup::"

# Install Additional Packages
/ctx/build_files/base/01-packages.sh

# Install Flatpaks

# remove other flatpaks
flatpak --system -y uninstall --all 
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
xargs flatpak --system -y install --or-update < /etc/ublue-os/system-flatpaks.list