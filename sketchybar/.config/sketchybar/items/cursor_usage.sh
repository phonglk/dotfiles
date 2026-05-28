#!/usr/bin/env sh

# Drop-in Cursor usage item for SketchyBar.
# Source this file from sketchybarrc after the bar defaults are configured.

CURSOR_USAGE_CONFIG="${CURSOR_USAGE_CONFIG:-$HOME/.config/sketchybar/cursor_usage.conf}"
[ -f "$CURSOR_USAGE_CONFIG" ] && . "$CURSOR_USAGE_CONFIG"

CURSOR_USAGE_PLUGIN_DIR="${CURSOR_USAGE_PLUGIN_DIR:-$HOME/.config/sketchybar/plugins}"

CURSOR_USAGE_POSITION="${CURSOR_USAGE_POSITION:-left}"
CURSOR_USAGE_DISPLAY="${CURSOR_USAGE_DISPLAY:-1}"
CURSOR_USAGE_UPDATE_FREQ="${CURSOR_USAGE_UPDATE_FREQ:-60}"
CURSOR_USAGE_SPACER_WIDTH="${CURSOR_USAGE_SPACER_WIDTH:-8}"

CURSOR_USAGE_COLOR_BG="${CURSOR_USAGE_COLOR_BG:-0xff2e3440}"
CURSOR_USAGE_COLOR_ROW_BG="${CURSOR_USAGE_COLOR_ROW_BG:-0xff3b4252}"
CURSOR_USAGE_COLOR_TEXT="${CURSOR_USAGE_COLOR_TEXT:-0xffeceff4}"
CURSOR_USAGE_COLOR_ICON_TEXT="${CURSOR_USAGE_COLOR_ICON_TEXT:-0xff2e3440}"
CURSOR_USAGE_COLOR_OK="${CURSOR_USAGE_COLOR_OK:-0xffa3be8c}"
CURSOR_USAGE_COLOR_RESET="${CURSOR_USAGE_COLOR_RESET:-0xffd8dee9}"
CURSOR_USAGE_COLOR_MUTED="${CURSOR_USAGE_COLOR_MUTED:-0xff4c566a}"

sketchybar --add item cursor_usage_sep "$CURSOR_USAGE_POSITION" \
    --set cursor_usage_sep \
    icon="" \
    label.drawing=off \
    width="$CURSOR_USAGE_SPACER_WIDTH" \
    associated_display="$CURSOR_USAGE_DISPLAY"

sketchybar --add item cursor_usage_icon "$CURSOR_USAGE_POSITION" \
    --set cursor_usage_icon \
    icon= \
    icon.font="Hack Nerd Font:Bold:15.0" \
    icon.color="$CURSOR_USAGE_COLOR_ICON_TEXT" \
    icon.padding_left=8 \
    icon.padding_right=8 \
    label.drawing=off \
    background.color="$CURSOR_USAGE_COLOR_OK" \
    background.height=28 \
    background.corner_radius=4 \
    associated_display="$CURSOR_USAGE_DISPLAY" \
    click_script="$CURSOR_USAGE_PLUGIN_DIR/cursor_usage_click.sh"

sketchybar --add item cursor_usage "$CURSOR_USAGE_POSITION" \
    --set cursor_usage \
    icon.drawing=off \
    label="..." \
    label.font="Hack Nerd Font:Bold:16.0" \
    label.color="$CURSOR_USAGE_COLOR_TEXT" \
    label.padding_left=6 \
    label.padding_right=8 \
    popup.background.color="$CURSOR_USAGE_COLOR_BG" \
    popup.background.corner_radius=8 \
    popup.background.border_color="$CURSOR_USAGE_COLOR_OK" \
    popup.background.border_width=2 \
    popup.background.padding_left=4 \
    popup.background.padding_right=4 \
    associated_display="$CURSOR_USAGE_DISPLAY" \
    update_freq="$CURSOR_USAGE_UPDATE_FREQ" \
    script="$CURSOR_USAGE_PLUGIN_DIR/cursor_usage.sh" \
    click_script="$CURSOR_USAGE_PLUGIN_DIR/cursor_usage_click.sh"

sketchybar --add bracket _cursor_usage \
    cursor_usage_icon \
    cursor_usage \
    --set _cursor_usage \
    background.color="$CURSOR_USAGE_COLOR_BG" \
    background.border_color="$CURSOR_USAGE_COLOR_OK" \
    background.border_width=2 \
    background.corner_radius=4

sketchybar --add item cursor_usage_pct popup.cursor_usage \
    --set cursor_usage_pct \
    icon=󰁝 \
    icon.font="Hack Nerd Font:Bold:10.0" \
    icon.color="$CURSOR_USAGE_COLOR_OK" \
    icon.padding_left=10 \
    icon.padding_right=8 \
    label="Usage" \
    label.font="Hack Nerd Font:Regular:12.0" \
    label.color="$CURSOR_USAGE_COLOR_TEXT" \
    label.padding_right=10 \
    background.color="$CURSOR_USAGE_COLOR_ROW_BG" \
    background.height=28 \
    background.corner_radius=4 \
    background.padding_left=5 \
    background.padding_right=5 \
    drawing=off \
    click_script="$CURSOR_USAGE_PLUGIN_DIR/cursor_usage_click.sh dashboard"

sketchybar --add item cursor_usage_reset popup.cursor_usage \
    --set cursor_usage_reset \
    icon=󰃭 \
    icon.font="Hack Nerd Font:Bold:10.0" \
    icon.color="$CURSOR_USAGE_COLOR_RESET" \
    icon.padding_left=10 \
    icon.padding_right=8 \
    label="Reset" \
    label.font="Hack Nerd Font:Regular:12.0" \
    label.color="$CURSOR_USAGE_COLOR_TEXT" \
    label.padding_right=10 \
    background.color="$CURSOR_USAGE_COLOR_ROW_BG" \
    background.height=28 \
    background.corner_radius=4 \
    background.padding_left=5 \
    background.padding_right=5 \
    drawing=off \
    click_script="$CURSOR_USAGE_PLUGIN_DIR/cursor_usage_click.sh dashboard"

sketchybar --add item cursor_usage_status popup.cursor_usage \
    --set cursor_usage_status \
    icon=󰒓 \
    icon.font="Hack Nerd Font:Bold:10.0" \
    icon.color="$CURSOR_USAGE_COLOR_MUTED" \
    icon.padding_left=10 \
    icon.padding_right=8 \
    label="Status" \
    label.font="Hack Nerd Font:Regular:12.0" \
    label.color="$CURSOR_USAGE_COLOR_TEXT" \
    label.padding_right=10 \
    background.color="$CURSOR_USAGE_COLOR_ROW_BG" \
    background.height=28 \
    background.corner_radius=4 \
    background.padding_left=5 \
    background.padding_right=5 \
    drawing=off \
    click_script="$CURSOR_USAGE_PLUGIN_DIR/cursor_usage_click.sh dashboard"
