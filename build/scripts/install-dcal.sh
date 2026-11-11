set -euo pipefail
cd /tmp

git clone --recurse-submodules https://github.com/duxlabs-dev/dux-calendar.git
cd dux-calendar
make install
make install-systemd
systemctl --global enable dcal