#!/usr/bin/sh

set -ouex pipefail

dnf group install -y \
	base-graphical \
	container-management \
	core \
	firefox \
	fonts \
	gnome-desktop \
	guest-desktop-agents \
	hardware-support \
	multimedia \
	networkmanager-submodules \
	printing \
	virtualization \
	workstation-product \
	vlc \
	--exclude=rootfiles \
	; dnf -y clean all

dnf install -y --skip-unavailable \
	bash-completion \
	bcc-tools \
	gnome-tweaks \
	htop \
	neovim \
	strace \
	tmate \
	vgrep \
	git \
	; dnf -y clean all

dnf remove -y \
	brltty \
	abrt