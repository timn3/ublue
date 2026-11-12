set -euo pipefail
cd /tmp

echo "==> Installing build dependencies"
dnf5 install -y \
    make \
    go

echo "==> Cloning dux-calendar repository and building dcal"
git clone --recurse-submodules https://github.com/duxlabs-dev/dux-calendar.git
cd dux-calendar
GOTOOLCHAIN=auto make
make install
# make install-systemd

echo "==> Installing dcal systemd service"
# install -Dm644 /tmp/dux-calendar/assets/systemd/dcal.service /usr/lib/systemd/user/dcal.service
systemctl --global enable dcal

echo "==> Cleaning up build dependencies"
dnf5 remove -y \
    make \
    go
