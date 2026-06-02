#!/usr/bin/env bash

stats=(
	stats_cpu
	stats_memory
	stats_disk
	stats_down
	stats_up
)

hide_stats() {
	args=()
	for item in "${stats[@]}"; do
		args+=(--set "$item" drawing=off)
	done

	sketchybar "${args[@]}" \
		--set stats_toggle icon=
}

show_stats() {
	args=()
	for item in "${stats[@]}"; do
		args+=(--set "$item" drawing=on)
	done

	sketchybar "${args[@]}" \
		--set stats_toggle icon= \
		--trigger stats_update
}

toggle_stats() {
	state=$(sketchybar --query stats_toggle 2>/dev/null | jq -r '.icon.value // empty')

	case "$state" in
		"") show_stats ;;
		*) hide_stats ;;
	esac
}

case "$SENDER" in
	hide_stats) hide_stats ;;
	show_stats) show_stats ;;
	toggle_stats) toggle_stats ;;
esac
