#!/usr/bin/env sh

STATS_PLUGIN_DIR="${STATS_PLUGIN_DIR:-$HOME/.config/sketchybar/plugins}"

sketchybar --add event hide_stats \
	--add event show_stats \
	--add event toggle_stats \
	--add event stats_update

sketchybar --add item stats_animator right \
	--set stats_animator \
	drawing=off \
	updates=on \
	script="$STATS_PLUGIN_DIR/stats_toggle.sh" \
	--subscribe stats_animator hide_stats show_stats toggle_stats

sketchybar -m --add item stats_cpu right \
	--set stats_cpu \
	drawing=off \
	update_freq=5 \
	icon= \
	icon.color="0xff${COL_BLUE}" \
	icon.font="Hack Nerd Font:Bold:15.0" \
	label.font="Hack Nerd Font:Bold:12.0" \
	label.color="0xff${COL_SNOW_WHITE}" \
	label.padding_right=8 \
	script="$STATS_PLUGIN_DIR/stats_cpu.sh" \
	associated_display=1 \
	--subscribe stats_cpu stats_update

sketchybar -m --add item stats_memory right \
	--set stats_memory \
	drawing=off \
	update_freq=15 \
	icon=﬙ \
	icon.color="0xff${COL_GREEN}" \
	icon.font="Hack Nerd Font:Bold:15.0" \
	label.font="Hack Nerd Font:Bold:12.0" \
	label.color="0xff${COL_SNOW_WHITE}" \
	label.padding_right=8 \
	script="$STATS_PLUGIN_DIR/stats_memory.sh" \
	associated_display=1 \
	--subscribe stats_memory stats_update

sketchybar -m --add item stats_disk right \
	--set stats_disk \
	drawing=off \
	update_freq=60 \
	icon= \
	icon.color="0xff${COL_ORANGE}" \
	icon.font="Hack Nerd Font:Bold:15.0" \
	label.font="Hack Nerd Font:Bold:12.0" \
	label.color="0xff${COL_SNOW_WHITE}" \
	label.padding_right=8 \
	script="$STATS_PLUGIN_DIR/stats_disk.sh" \
	associated_display=1 \
	--subscribe stats_disk stats_update

sketchybar -m --add item stats_down right \
	--set stats_down \
	drawing=off \
	update_freq=3 \
	icon= \
	icon.color="0xff${COL_BLUE}" \
	icon.font="Hack Nerd Font:Bold:13.0" \
	label.font="Hack Nerd Font:Bold:11.0" \
	label.color="0xff${COL_SNOW_WHITE}" \
	label.padding_right=8 \
	script="$STATS_PLUGIN_DIR/stats_network.sh" \
	associated_display=1 \
	--subscribe stats_down stats_update

sketchybar -m --add item stats_up right \
	--set stats_up \
	drawing=off \
	icon= \
	icon.color="0xff${COL_GREEN}" \
	icon.font="Hack Nerd Font:Bold:13.0" \
	label.font="Hack Nerd Font:Bold:11.0" \
	label.color="0xff${COL_SNOW_WHITE}" \
	label.padding_right=8 \
	associated_display=1

sketchybar -m --add item stats_toggle right \
	--set stats_toggle \
	icon= \
	icon.font="Hack Nerd Font:Bold:16.0" \
	icon.color="0xff${COL_BLACK}" \
	label.drawing=off \
	background.color="0xff${COL_ORANGE}" \
	background.corner_radius=4 \
	click_script="sketchybar --trigger toggle_stats" \
	associated_display=1

sketchybar --add bracket _stats \
	stats_cpu \
	stats_memory \
	stats_disk \
	stats_down \
	stats_up \
	stats_toggle \
	--set _stats \
	background.color="0xff${COL_BLACK}" \
	background.border_color="0xff${COL_ORANGE}" \
	background.border_width=2 \
	background.corner_radius=4
