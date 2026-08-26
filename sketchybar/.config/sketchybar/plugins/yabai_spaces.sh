#!/usr/bin/env bash

SKETCHYBAR_CMD="${SKETCHYBAR_CMD:-sketchybar}"
YABAI_CMD="${YABAI_CMD:-yabai}"
PLUGIN_DIR="${PLUGIN_DIR:-$HOME/.config/sketchybar/plugins}"
APP_ICON_MAP="${APP_ICON_MAP:-$PLUGIN_DIR/app_icon_map.sh}"
YABAI_SPACES_DISPLAY="${YABAI_SPACES_DISPLAY:-1}"

BLACK="0xff2e3440"
DARK_WHITE="0xffd8dee9"
GREY="0xff434c5e"
GREEN="0xffa3be8c"

bar() {
	"$SKETCHYBAR_CMD" "$@" >/dev/null 2>&1
}

space_item_name() {
	printf 'yabai_space.%s' "$1"
}

app_icon() {
	if [[ -x "$APP_ICON_MAP" ]]; then
		"$APP_ICON_MAP" "$1"
	else
		printf ':default:'
	fi
}

space_app_icons() {
	local space="$1"
	local windows_json="$2"
	local apps icon_line="" app icon

	apps=$(printf '%s' "$windows_json" |
		jq -r --argjson space "$space" '.[] | select(.space == $space) | select(."is-minimized" == false) | select(.app != "") | .app' 2>/dev/null |
		awk 'NF && !seen[$0]++' || true)

	while IFS= read -r app; do
		[[ -z "$app" ]] && continue
		icon="$(app_icon "$app")"
		if [[ -n "$icon_line" ]]; then
			icon_line+="  "
		fi
		icon_line+="$icon"
	done <<<"$apps"

	printf '%s' "$icon_line"
}

ensure_space_item() {
	local index="$1"
	local item

	item=$(space_item_name "$index")
	if "$SKETCHYBAR_CMD" --query "$item" >/dev/null 2>&1; then
		return
	fi

	bar --add space "$item" left \
		--set "$item" \
		associated_display="$YABAI_SPACES_DISPLAY" \
		associated_space="$index" \
		padding_right=3 \
		icon="$index" \
		icon.font="Hack Nerd Font:Bold:13.0" \
		icon.color="$DARK_WHITE" \
		icon.highlight_color="$BLACK" \
		icon.padding_left=8 \
		icon.padding_right=5 \
		label="" \
		label.font="sketchybar-app-font:Regular:15.0" \
		label.color="$DARK_WHITE" \
		label.highlight_color="$BLACK" \
		label.padding_left=2 \
		label.padding_right=8 \
		background.color="$BLACK" \
		background.border_color="$GREY" \
		background.border_width=1 \
		background.height=24 \
		background.corner_radius=5 \
		click_script="$YABAI_CMD -m space --focus $index"
}

remove_stale_space_items() {
	local desired="$1"
	local item index

	while IFS= read -r item; do
		[[ -z "$item" ]] && continue
		index="${item#yabai_space.}"
		if ! printf '%s\n' "$desired" | grep -qx "$index"; then
			bar --remove "$item"
		fi
	done < <("$SKETCHYBAR_CMD" --query bar 2>/dev/null |
		jq -r '.items[] | select(startswith("yabai_space."))' 2>/dev/null || true)
}

refresh_spaces() {
	local spaces_json windows_json focused_space indexes
	local index item icons selected border_color bg_color text_color previous_item

	spaces_json=$("$YABAI_CMD" -m query --spaces --display "$YABAI_SPACES_DISPLAY" 2>/dev/null) || return 1
	windows_json=$("$YABAI_CMD" -m query --windows 2>/dev/null || printf '[]')
	focused_space=$(printf '%s' "$spaces_json" | jq -r '.[] | select(."has-focus" == true) | .index' 2>/dev/null | head -n 1)
	indexes=$(printf '%s' "$spaces_json" | jq -r '.[].index' 2>/dev/null)

	remove_stale_space_items "$indexes"

	previous_item="logo"
	while IFS= read -r index; do
		[[ -z "$index" ]] && continue
		item=$(space_item_name "$index")
		ensure_space_item "$index"
		icons=$(space_app_icons "$index" "$windows_json")

		if [[ "$index" == "$focused_space" ]]; then
			selected=on
			border_color="$GREEN"
			bg_color="$GREEN"
			text_color="$BLACK"
		else
			selected=off
			border_color="$GREY"
			bg_color="$BLACK"
			text_color="$DARK_WHITE"
		fi

		bar --set "$item" \
			drawing=on \
			padding_right=3 \
			icon.highlight="$selected" \
			label.highlight="$selected" \
			label="$icons" \
			background.border_color="$border_color" \
			background.color="$bg_color" \
			icon.color="$text_color" \
			icon.highlight_color="$text_color" \
			label.color="$text_color" \
			label.highlight_color="$text_color"
		bar --move "$item" after "$previous_item"
		previous_item="$item"
	done <<<"$indexes"
}

LOCK_DIR="/tmp/sketchybar-yabai-spaces.lock"
if ! mkdir "$LOCK_DIR" 2>/dev/null; then
	lock_pid="$(cat "$LOCK_DIR/pid" 2>/dev/null || true)"
	if [[ -n "$lock_pid" ]] && kill -0 "$lock_pid" 2>/dev/null; then
		exit 0
	fi
	rm -rf "$LOCK_DIR"
	if ! mkdir "$LOCK_DIR" 2>/dev/null; then
		exit 0
	fi
fi
printf '%s\n' "$$" > "$LOCK_DIR/pid"
trap 'rm -rf "$LOCK_DIR" 2>/dev/null || true' EXIT

refresh_spaces
