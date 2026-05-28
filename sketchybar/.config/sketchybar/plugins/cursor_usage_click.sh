#!/usr/bin/env bash

CONFIG_FILE="${CURSOR_USAGE_CONFIG:-$HOME/.config/sketchybar/cursor_usage.conf}"
CURSOR_USAGE_CLICK_URL="https://cursor.com/dashboard"
SKETCHYBAR_CMD="${SKETCHYBAR_CMD:-sketchybar}"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

case "${1:-toggle}" in
    dashboard)
        open "$CURSOR_USAGE_CLICK_URL"
        "$SKETCHYBAR_CMD" --set cursor_usage popup.drawing=off
        ;;
    *)
        "$SKETCHYBAR_CMD" --set cursor_usage popup.drawing=toggle
        ;;
esac
