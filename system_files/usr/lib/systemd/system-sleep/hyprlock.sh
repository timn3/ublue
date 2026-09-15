#!/bin/sh
set -eu

# ── Resolve the graphical user ──────────────────────────────────────────────
HYPR_USER="${HYPRLOCK_SLEEP_USER:-}"

if [ -z "$HYPR_USER" ]; then
    HYPR_USER=$(loginctl list-sessions --no-legend 2>/dev/null \
        | awk '{print $1}' \
        | while read -r sid; do
            loginctl show-session "$sid" -p Name -p Type -p Active --value 2>/dev/null \
                | { read -r name; read -r type; read -r active;
                    if [ "$active" = "yes" ] && [ "$type" = "wayland" ]; then
                        echo "$name"
                    fi
                  }
          done | head -n1)
fi

if [ -z "$HYPR_USER" ]; then
    logger -t hyprlock-sleep "could not resolve graphical user, skipping lock"
    exit 0
fi

USER_ID=$(id -u "$HYPR_USER")
export XDG_RUNTIME_DIR="/run/user/$USER_ID"

# ── Lock screen ─────────────────────────────────────────────────────────────
case "$1" in
  pre)
    su - "$HYPR_USER" -c "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR hyprlock -c /home/$HYPR_USER/.config/hypr/hyprlock.conf &" \
        || logger -t hyprlock-sleep "failed to launch hyprlock"

    # Block suspend until hyprlock is actually up and rendered, capped
    # at 2s so a stuck/missing hyprlock never hangs a suspend indefinitely.
    i=0
    while [ "$i" -lt 40 ]; do
        if pgrep -x hyprlock >/dev/null 2>&1; then
            break
        fi
        i=$((i + 1))
        sleep 0.05
    done
    ;;
  post)
    # No-op: hypridle's after_sleep_cmd handles dpms/screen-on.
    ;;
esac
