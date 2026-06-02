#!/usr/bin/env sh

WEATHER_PLUGIN_DIR="${WEATHER_PLUGIN_DIR:-$HOME/.config/sketchybar/plugins}"

sketchybar -m --add item weather_label right \
	--set weather_label \
	update_freq=600 \
	label.padding_right=8 \
	label.max_chars=8 \
	icon.drawing=off \
	script="$WEATHER_PLUGIN_DIR/weather.sh" \
	click_script="sketchybar --set weather_label popup.drawing=toggle" \
	popup.background.color="0xff${COL_BLACK}" \
	popup.background.corner_radius=8 \
	popup.background.border_color="0xff${COL_SKY_BLUE}" \
	popup.background.border_width=2 \
	popup.background.padding_left=4 \
	popup.background.padding_right=4 \
	associated_display=1

sketchybar -m --add item weather_icon right \
	--set weather_icon \
	icon= \
	icon.font="Hack Nerd Font:Bold:17.0" \
	icon.color="0xff${COL_BLACK}" \
	label.drawing=off \
	background.color="0xff${COL_SKY_BLUE}" \
	background.corner_radius=4 \
	associated_display=1 \
	click_script="sketchybar --set weather_label popup.drawing=toggle"

sketchybar --add bracket _weather \
	weather_label \
	weather_icon \
	--set _weather \
	background.color="0xff${COL_BLACK}" \
	background.border_color="0xff${COL_SKY_BLUE}" \
	background.border_width=2 \
	background.corner_radius=4

sketchybar -m --add item weather_stats_sep right \
	--set weather_stats_sep \
	icon.drawing=off \
	label.drawing=off \
	width=10 \
	associated_display=1

for item in weather_summary weather_feels weather_wind weather_today weather_tomorrow; do
	sketchybar --add item "$item" popup.weather_label \
		--set "$item" \
		drawing=off \
		icon.font="Hack Nerd Font:Bold:13.0" \
		icon.padding_left=10 \
		icon.padding_right=8 \
		label.font="Hack Nerd Font:Regular:12.0" \
		label.color="0xff${COL_SNOW_WHITE}" \
		label.padding_right=10 \
		background.color="0xff${COL_LIGHT_BLACK}" \
		background.height=28 \
		background.corner_radius=4 \
		background.padding_left=5 \
		background.padding_right=5 \
		click_script="sketchybar --set weather_label popup.drawing=off"
done
