#!/usr/bin/sh
set -ouex pipefail

### Copy custom system files
rsync -rvK /ctx/system_files/ /

### Install packages
# Activate non-free rpmfusion repos
dnf5 -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

### Add Terra
dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

### Install codecs
dnf5 -y install \
        rpmfusion-free-release \
        rpmfusion-nonfree-release

### Media codecs
dnf5 -y group install multimedia
dnf5 -y swap 'ffmpeg-free' 'ffmpeg' --allowerasing # Switch to full FFMPEG.
dnf5 -y upgrade @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin # Installs gstreamer components. Required if you use Gnome Videos and other dependent applications.
dnf5 -y group install -y sound-and-video # Installs useful Sound and Video complementary packages.

### HW Accelerattion
dnf5 -y install ffmpeg-libs libva libva-utils
## Intel
dnf5 -y swap libva-intel-media-driver intel-media-driver --allowerasing
dnf5 -y install libva-intel-driver \
        gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-ugly gstreamer1-vaapi
## AMD
# dnf -y swap mesa-va-drivers mesa-va-drivers-freeworld
# dnf -y swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
# dnf -y swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
# dnf -y swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686

dnf5 install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264
dnf5 config-manager setopt fedora-cisco-openh264.enabled=1

PACKAGE_LIST=$(dnf5 list --installed | awk '{ print $1 }' | grep gnome ) 
dnf5 remove -y $PACKAGE_LIST

### Install programs
# Install CLI tools
dnf5 install -y \
    bat \
    btop \
    distrobox \
    fastfetch \
    fd \
    fuse \
    fzf \
    htop \
    lm_sensors \
    nautilus-python \
    rg \
    zoxide \
    zsh \
    neovim \
    v4l-utils \
    ffmpeg

# Install eza
sh /ctx/scripts/install_scripts/install-eza.sh

# Install cosign
sh /ctx/scripts/install_scripts/install-cosign.sh

### Install hyprland
dnf5 -y update
dnf5 -y copr enable lionheartp/hyprland
dnf5 -y copr enable erikreider/SwayOSD
dnf5 -y copr enable aylur/ags
dnf5 -y copr enable heus-sueh/packages

dnf5 -y install \
    hyprland hyprlock hypridle hyprpaper \
    xdg-desktop-portal-hyprland \
    polkit-gnome \
    brightnessctl playerctl wl-clipboard \
    grim slurp inotify-tools
dnf5 -y --skip-unavailable install \
    adw-gtk3-theme papirus-icon-theme \
    nautilus ptyxis loupe \
    gnome-keyring network-manager-applet \
    google-noto-sans-fonts google-noto-emoji-fonts
dnf5 -y install ags swayosd
dnf5 -y install hyprlauncher wireplumber upower libgtop2 bluez bluez-tools grimblast hyprpicker btop NetworkManager wl-clipboard swww brightnessctl gnome-bluetooth aylurs-gtk-shell power-profiles-daemon gvfs nodejs wf-recorder
npm install -g --silent sass
dnf5 -y install python python3-pip; pip install gpustat pywal


# dnf5 -y copr enable lionheartp/Hyprland 
# dnf5 -y install wofi dunst blueman nm-applet tuned-switcher wlogout


### Install mango wm
# dnf5 -y install mangowm
# dnf5 -y install waybar swaybg swayidle swaylock wofi grim slurp mako blueman nm-applet tuned-switcher wlroots nmtui brightnessctl bluetoothctl pavucontrol swaync xdg-desktop-portal-wlr wmenu foot kitty wlopm
# dnf5 -y copr enable erikreider/swayosd
# dnf5 -y install swayosd
# dnf5 -y copr enable solopasha/hyprland 
# dnf5 -y install hyprlock
# dnf5 -y copr enable prankstr/vibepanel
# dnf5 -y install vibepanel
# # copy over custom mango binaries
# rsync -rvK /ctx/system_files/usr/bin/ /usr/bin/

# Install starship
dnf5 -y copr enable atim/starship
dnf5 -y install starship
dnf5 -y copr disable atim/starship

### Enable services
# Disable NetworkManager-wait-online for faster (re-)boot
systemctl disable NetworkManager-wait-online.service
# Enable automatic update service
systemctl enable bootc-check-update.timer
