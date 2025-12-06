ARG FEDORA_MAJOR_VERSION="43"
ARG SOURCE_IMAGE="fedora-silverblue"

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY /scripts /scripts
COPY /flatpaks /flatpaks
COPY /system_files /system_files

# Base Image
FROM quay.io/fedora/${SOURCE_IMAGE}:${FEDORA_MAJOR_VERSION} AS base
# FROM ghcr.io/ublue-os/silverblue-nvidia:latest

# TODO move the following code in build_base.sh
# Make sure that the rootfiles package can be installed
RUN mkdir -p /var/roothome

# make flatpak install script executable
RUN chmod +x /usr/local/bin/flatpak-user-install.sh
# Enable service for automatic flatpak install
RUN systemctl --global enable flatpak-user-install.service

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/scripts/build_base.sh && \
    ostree container commit

#install rpmfusion
# RUN dnf install -y \
# 	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
# 	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# RUN systemctl mask systemd-remount-fs.service
# RUN systemctl set-default graphical.target

# See https://fedoraproject.org/wiki/Changes/UnprivilegedUpdatesAtomicDesktops:
#     Avoid annoying popups when logged in.
# RUN dnf install -y fedora-release-ostree-desktop \
# 	; dnf -y clean all

# Resize windows on super+mouse-right-click
# RUN gsettings set org.gnome.desktop.wm.preferences resize-with-right-button "true"

# Install all RPMs in ./additional_rpms
# RUN --mount=type=bind,source=./additional_rpms,target=/additional_rpms,Z \
# 	dnf -y --disablerepo='*' install --skip-unavailable /additional_rpms/*.rpm \
# 	; dnf -y clean all

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
