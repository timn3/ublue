#!/usr/bin/env bash
set -euo pipefail

notify-send \             
  --urgency=normal \
  --icon=system-software-update \
  "System Update Ready" \
  "A system update has been staged and will apply on next reboot."

bootc upgrade --check