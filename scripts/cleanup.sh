#!/usr/bin/sh
set -ouex pipefail

# got to /etc/yum.repos.d and remove the copr repos
rm /etc/yum.repos.d/copr:*
rm /etc/yum.repos.d/_copr:*
rm /etc/yum.repos.d/google-chrome.repo
rm /etc/yum.repos.d/terra.repo
rm /etc/yum.repos.d/netbird.repo
rm /etc/yum.repos.d/vscode.repo