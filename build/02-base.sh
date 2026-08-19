#!/usr/bin/sh
set -ouex pipefail

### Install CLI programs
dnf5 install -y \
    alacritty \
    bat \
    bluetoothctl \
    brightnessctl \
    btop \
    chezmoi \
    distrobox \
    dua-cli \
    fastfetch \
    fd-find \
    ffmpeg \
    foot \
    fuse \
    fuse-libs \
    fzf \
    gcc \
    git-delta \
    htop \
    jq \
    kanshi \
    libcamera-qcam \
    libcamera-tools \
    lm_sensors \
    make \
    nautilus-python \
    neovim \
    nmtui \
    powerstat \
    powertop \
    procs \
    rg \
    tree-sitter-cli \
    udiskie \
    v4l-utils \
    wofi \
    zoxide \
    zsh

# Install eza
sh /ctx/build/scripts/install-eza.sh

# Install battop
sh /ctx/build/scripts/install-battop.sh

# Install zellij
sh /ctx/build/scripts/install-zellij.sh

# Install vpn
dnf5 -y install \
    openconnect \
    NetworkManager-openconnect 

# Install howdy
dnf5 -y copr enable starfish/howdy-beta
dnf5 -y install howdy
dnf5 -y copr disable starfish/howdy-beta
mkdir -p /usr/lib/howdy
ln -s /usr/lib/python3.14/site-packages/howdy/recorders /usr/lib/howdy/recorders

dnf5 -y install \
    dkms \
    kernel-devel \
    v4l-utils \
    libcamera \
    pipewire-plugin-libcamera

cd /tmp
git clone https://github.com/jibsta210/svp7500-camera-fix-pack
cd svp7500-camera-fix-pack
HOWDY_RECORDERS=/usr/lib/python3.14/site-packages/howdy/recorders

install -Dm444 \
  howdy/ir_reader.py \
  "$HOWDY_RECORDERS/ir_reader.py"

python3 - <<'PY'
from pathlib import Path

p = Path("/usr/lib/python3.14/site-packages/howdy/recorders/video_capture.py")
s = p.read_text()

needle = '''\t\telif recording_plugin == "pyv4l2":
\t\t\t# Set the capture source for pyv4l2
\t\t\tfrom recorders.pyv4l2_reader import pyv4l2_reader
\t\t\tself.internal = pyv4l2_reader(
\t\t\t\tself.config.get("video", "device_path"),
\t\t\t\tself.config.get("video", "device_format", fallback="v4l2")
\t\t\t)

'''

insert = '''\t\telif recording_plugin == "pyv4l2":
\t\t\t# Set the capture source for pyv4l2
\t\t\tfrom recorders.pyv4l2_reader import pyv4l2_reader
\t\t\tself.internal = pyv4l2_reader(
\t\t\t\tself.config.get("video", "device_path"),
\t\t\t\tself.config.get("video", "device_format", fallback="v4l2")
\t\t\t)

\t\telif recording_plugin == "ir":
\t\t\t# Raw V4L2 reader for the HM1092 IR sensor on Intel IPU7.
\t\t\tfrom recorders.ir_reader import ir_reader
\t\t\tself.internal = ir_reader(
\t\t\t\tself.config.get("video", "device_path")
\t\t\t)

'''

if "from recorders.ir_reader import ir_reader" in s:
    print("IR hook already present")
elif needle not in s:
    raise SystemExit("Could not find pyv4l2 insertion point; Howdy source changed")
else:
    p.write_text(s.replace(needle, insert, 1))
    print("IR hook installed")
PY

sh ./install.sh --howdy-only --force

# Install yazi
dnf5 -y copr enable lihaohong/yazi
dnf5 -y install yazi
dnf5 -y copr disable lihaohong/yazi

# Install starship
dnf5 -y copr enable atim/starship
dnf5 -y install starship
dnf5 -y copr disable atim/starship
