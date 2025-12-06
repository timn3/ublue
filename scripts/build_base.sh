#!/usr/bin/sh

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux 

# remove other flatpaks

#flatpak --system -y uninstall --all 
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak --system -y install --or-update org.signal.Signal com.spotify.Client
install -Dm0644 -t /etc/tormed-os/ /ctx/flatpaks/*.list
if [[ "$(rpm -E %fedora)" -ge "43" ]]; then
  systemctl enable flatpak-preinstall.service
fi

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket