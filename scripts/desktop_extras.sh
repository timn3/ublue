#!/usr/bin/sh
set -ouex pipefail

# Install battop
sh /ctx/scripts/install_scripts/install-battop.sh

# Install netbird
sh /ctx/scripts/install_scripts/install-netbird.sh

# Install howdy
# TODO Solve dependency issues
# sh /ctx/scripts/install_scripts/install-howdy.sh

# Install zellij
sh /ctx/scripts/install_scripts/install-zellij.sh

# Install vs code
sh /ctx/scripts/install_scripts/install-vscode.sh