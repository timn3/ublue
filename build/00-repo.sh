#!/usr/bin/sh
set -ouex pipefail

### Copy custom system files
rsync -rvK /ctx/system_files/ /

### Activate non-free rpmfusion repos
dnf5 -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

### Add Terra
dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

### Install cosign
# https://edu.chainguard.dev/open-source/sigstore/cosign/how-to-install-cosign/#installing-cosign-with-the-cosign-binary
# Download the most recent binary:
curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"

# Next, move the Cosign binary to your bin folder:
sudo mv cosign-linux-amd64 /usr/local/bin/cosign

# Finally, update permissions so that Cosign can execute within your filesystem:
sudo chmod +x /usr/local/bin/cosign