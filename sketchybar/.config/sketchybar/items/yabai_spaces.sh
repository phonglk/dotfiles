#!/usr/bin/env sh

YABAI_SPACES_PLUGIN="${YABAI_SPACES_PLUGIN:-$HOME/.config/sketchybar/plugins/yabai_spaces.sh}"

for item in home video code web reserve chat primary_spaces _yabai_spaces yabai_spaces_observer; do
	sketchybar --remove "$item" >/dev/null 2>&1
done

sketchybar --add event yabai_spaces_update
sketchybar --add event space_windows_change

sketchybar -m --add item yabai_spaces_observer left \
	--set yabai_spaces_observer \
	drawing=off \
	updates=on \
	update_freq=15 \
	script="$YABAI_SPACES_PLUGIN >/tmp/sketchybar-yabai-spaces.log 2>&1" \
	associated_display=1 \
	--subscribe yabai_spaces_observer yabai_spaces_update space_change space_windows_change display_change system_woke front_app_switched

"$YABAI_SPACES_PLUGIN"

sketchybar --add bracket _yabai_spaces \
	logo \
	'/yabai_space\..*/' \
	--set _yabai_spaces \
	background.color="0xff${COL_BLACK}" \
	background.border_color="0xff${COL_GREEN}" \
	background.border_width=2 \
	background.corner_radius=4
