#!/usr/bin/env bash

CONFIG_DIR="${SKETCHYBAR_CONFIG_DIR:-$HOME/.config/sketchybar}"
CACHE_DIR="${SKETCHYBAR_CACHE_DIR:-$HOME/tmp/sketchybar-cache}"
CACHE_FILE="$CACHE_DIR/weather.json"
CACHE_TTL_SECONDS="${SKETCHYBAR_WEATHER_CACHE_TTL_SECONDS:-900}"
SKETCHYBAR_CMD="${SKETCHYBAR_CMD:-sketchybar}"

[[ -f "$CONFIG_DIR/.env" ]] && source "$CONFIG_DIR/.env"

LOCATION="${SKETCHYBAR_WEATHER_LOCATION:-}"
UNITS="${SKETCHYBAR_WEATHER_UNITS:-m}"

GREEN="0xffa3be8c"
RED="0xffbf616a"
YELLOW="0xffebcb8b"
BLUE="0xff5e81ac"
SKY_BLUE="0xff81a1c1"
GREY="0xff4c566a"
WHITE="0xffeceff4"

mkdir -p "$CACHE_DIR"

weather_url() {
	local encoded_location query

	encoded_location="${LOCATION// /+}"
	query="format=j1&$UNITS"

	if [[ -n "$encoded_location" ]]; then
		printf 'https://wttr.in/%s?%s\n' "$encoded_location" "$query"
	else
		printf 'https://wttr.in/?%s\n' "$query"
	fi
}

cache_is_fresh() {
	[[ -s "$CACHE_FILE" ]] || return 1

	local now modified
	now=$(date +%s)
	modified=$(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0)
	((now - modified < CACHE_TTL_SECONDS))
}

refresh_weather() {
	local tmp_file

	cache_is_fresh && return 0

	tmp_file="$CACHE_FILE.$$"
	if curl -fsSL --connect-timeout 2 --max-time 6 "$(weather_url)" -o "$tmp_file"; then
		mv "$tmp_file" "$CACHE_FILE"
	else
		rm -f "$tmp_file"
	fi
}

icon_for() {
	local description hour
	description=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
	hour=$(date '+%H')

	case "$description" in
		*snow*) printf '' ;;
		*thunder*) printf '' ;;
		*rain*|*drizzle*|*shower*) printf '' ;;
		*fog*|*mist*) printf '' ;;
		*cloud*)
			if ((hour >= 6 && hour < 18)); then
				printf ''
			else
				printf ''
			fi
			;;
		*)
			if ((hour >= 6 && hour < 18)); then
				printf ''
			else
				printf ''
			fi
			;;
	esac
}

unit_label() {
	case "$UNITS" in
		u) printf 'F' ;;
		*) printf 'C' ;;
	esac
}

set_row() {
	local item="$1"
	local icon="$2"
	local icon_color="$3"
	local label="$4"

	"$SKETCHYBAR_CMD" --set "$item" \
		drawing=on \
		icon="$icon" \
		icon.color="$icon_color" \
		label="$label"
}

hide_rows() {
	for item in weather_summary weather_feels weather_wind weather_today weather_tomorrow; do
		"$SKETCHYBAR_CMD" --set "$item" drawing=off
	done
}

refresh_weather

if [[ ! -s "$CACHE_FILE" ]] || ! jq -e '.current_condition[0]' "$CACHE_FILE" >/dev/null 2>&1; then
	"$SKETCHYBAR_CMD" --set weather_label label="--" \
		--set weather_icon icon="" background.color="$RED" \
		--set _weather background.border_color="$RED"
	hide_rows
	exit 0
fi

case "$UNITS" in
	u)
		temp_field="temp_F"
		feels_field="FeelsLikeF"
		max_field="maxtempF"
		min_field="mintempF"
		unit=$(unit_label)
		;;
	*)
		temp_field="temp_C"
		feels_field="FeelsLikeC"
		max_field="maxtempC"
		min_field="mintempC"
		unit=$(unit_label)
		;;
esac

temp=$(jq -r ".current_condition[0].$temp_field // empty" "$CACHE_FILE")
feels=$(jq -r ".current_condition[0].$feels_field // empty" "$CACHE_FILE")
description=$(jq -r '.current_condition[0].weatherDesc[0].value // "Weather"' "$CACHE_FILE")
humidity=$(jq -r '.current_condition[0].humidity // empty' "$CACHE_FILE")
wind=$(jq -r '.current_condition[0].windspeedKmph // empty' "$CACHE_FILE")
place=$(jq -r '.nearest_area[0].areaName[0].value // empty' "$CACHE_FILE")
icon=$(icon_for "$description")

if [[ -z "$temp" ]]; then
	temp="--"
fi

"$SKETCHYBAR_CMD" --set weather_label label="${temp}°" \
	--set weather_icon icon="$icon" background.color="$SKY_BLUE" \
	--set _weather background.border_color="$SKY_BLUE" \
	--set weather_summary label.max_chars=42 \
	--set weather_feels label.max_chars=42 \
	--set weather_wind label.max_chars=42 \
	--set weather_today label.max_chars=42 \
	--set weather_tomorrow label.max_chars=42

set_row weather_summary "$icon" "$SKY_BLUE" "${place:-Weather} · $description"
set_row weather_feels "󰔏" "$YELLOW" "Feels ${feels:-$temp}°$unit · Humidity ${humidity:-?}%"
set_row weather_wind "󰖝" "$GREEN" "Wind ${wind:-?} km/h"

for row in 0 1; do
	date_label=$(jq -r ".weather[$row].date // empty" "$CACHE_FILE")
	max_temp=$(jq -r ".weather[$row].$max_field // empty" "$CACHE_FILE")
	min_temp=$(jq -r ".weather[$row].$min_field // empty" "$CACHE_FILE")
	day_desc=$(jq -r ".weather[$row].hourly[4].weatherDesc[0].value // .weather[$row].hourly[0].weatherDesc[0].value // empty" "$CACHE_FILE")
	day_icon=$(icon_for "$day_desc")

	if [[ "$row" -eq 0 ]]; then
		set_row weather_today "$day_icon" "$BLUE" "Today ${min_temp:-?}°/${max_temp:-?}°$unit · ${day_desc:-Forecast}"
	else
		set_row weather_tomorrow "$day_icon" "$GREY" "Tomorrow ${min_temp:-?}°/${max_temp:-?}°$unit · ${day_desc:-Forecast}"
	fi
done
