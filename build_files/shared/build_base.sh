#!/usr/bin/env bash

set -eoux pipefail

mkdir -p /var/roothome

echo "::group:: ===Install dnf5==="
if [ "${FEDORA_MAJOR_VERSION}" -lt 41 ]; then
    rpm-ostree install --idempotent dnf5 dnf5-plugins
fi

echo "::endgroup::"

echo "::group:: Copy Files"

# Copy ISO list for `install-system-flaptaks`
install -Dm0644 -t /etc/ublue-os/ /ctx/flatpaks/*.list

echo "::endgroup::"

# Install Additional Packages
/ctx/build_files/base/01-packages.sh