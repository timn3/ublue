# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/silverblue-nvidia:latest
#FROM ghcr.io/ublue-os/bazzite:stable

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

# # Make sure that the rootfiles package can be installed
# RUN mkdir -p /var/roothome

# #install rpmfusion
# RUN dnf install -y \
# 	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
# 	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# RUN dnf group install -y \
# 	base-graphical \
# 	container-management \
# 	core \
# 	firefox \
# 	fonts \
# 	gnome-desktop \
# 	guest-desktop-agents \
# 	hardware-support \
# 	multimedia \
# 	networkmanager-submodules \
# 	printing \
# 	virtualization \
# 	workstation-product \
# 	; dnf -y clean all

# RUN dnf install -y \
# 	bash-completion \
# 	bcc-tools \
# 	gnome-tweaks \
# 	htop \
# 	neovim \
# 	strace \
# 	tmate \
# 	tmux \
# 	vgrep \
# 	; dnf -y clean all

# RUN systemctl set-default graphical.target

# # See https://fedoraproject.org/wiki/Changes/UnprivilegedUpdatesAtomicDesktops:
# #     Avoid annoying popups when logged in.
# RUN dnf install -y fedora-release-ostree-desktop \
# 	; dnf -y clean all

# # Resize windows on super+mouse-right-click
# RUN gsettings set org.gnome.desktop.wm.preferences resize-with-right-button "true"

# # Install all RPMs in ./additional_rpms
# RUN --mount=type=bind,source=./additional_rpms,target=/additional_rpms,Z \
# 	dnf -y --disablerepo='*' install --skip-unavailable /additional_rpms/*.rpm \
# 	; dnf -y clean all

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
