#!/usr/bin/env bash

GREEN="0xffa3be8c"
BLUE="0xff5e81ac"

primary_interface=$(route get default 2>/dev/null | awk '/interface:/ { print $2; exit }')
primary_interface="${primary_interface:-en0}"

read_bytes() {
	netstat -ibn -I "$primary_interface" 2>/dev/null | awk -v iface="$primary_interface" '
		$1 == iface && $7 ~ /^[0-9]+$/ && $10 ~ /^[0-9]+$/ {
			print $7, $10
			exit
		}
	'
}

human_rate() {
	local bytes="$1"

	awk -v bytes="$bytes" '
		BEGIN {
			if (bytes >= 1048576) {
				printf "%.1fM/s", bytes / 1048576
			} else if (bytes >= 1024) {
				printf "%.0fK/s", bytes / 1024
			} else {
				printf "%.0fB/s", bytes
			}
		}
	'
}

read -r rx_a tx_a <<<"$(read_bytes)"
sleep 1
read -r rx_b tx_b <<<"$(read_bytes)"

rx_delta=$(( ${rx_b:-0} - ${rx_a:-0} ))
tx_delta=$(( ${tx_b:-0} - ${tx_a:-0} ))

((rx_delta < 0)) && rx_delta=0
((tx_delta < 0)) && tx_delta=0

down=$(human_rate "$rx_delta")
up=$(human_rate "$tx_delta")

sketchybar --set stats_down label="$down" icon.color="$BLUE" \
	--set stats_up label="$up" icon.color="$GREEN"
