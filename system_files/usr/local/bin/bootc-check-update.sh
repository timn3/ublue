#!/usr/bin/env bash
set -euo pipefail

notify-send \
 --urgency=normal \
 --icon=system-software-update \
 "System Update Ready" \
 "A system update has been is available. Run 'sudo bootc upgrade' to apply it."

sudo bootc upgrade --check