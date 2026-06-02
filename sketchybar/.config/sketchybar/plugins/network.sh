#!/usr/bin/env bash

GREEN="0xffa3be8c"
RED="0xffbf616a"
BLUE="0xff5e81ac"
YELLOW="0xffebcb8b"
GREY="0xff4c566a"

wifi_device=$(networksetup -listallhardwareports 2>/dev/null | awk '
	/Wi-Fi|AirPort/ {
		getline
		print $2
		exit
	}
')

ip_address=""
ssid=""

if [[ -n "$wifi_device" ]]; then
	ip_address=$(ipconfig getifaddr "$wifi_device" 2>/dev/null || true)
	ssid=$(ipconfig getsummary "$wifi_device" 2>/dev/null | awk -F ' SSID : ' '/ SSID : / { print $2; exit }')
fi

if [[ -z "$ip_address" ]]; then
	ip_address=$(scutil --nwi 2>/dev/null | awk '/address/ { print $3; exit }')
fi

vpn_name=$(scutil --nc list 2>/dev/null | awk -F '"' '/Connected/ { print $2; exit }')
if [[ -z "$vpn_name" ]] && scutil --nwi 2>/dev/null | grep -q 'utun'; then
	vpn_name="VPN"
fi

if [[ -z "$ip_address" ]]; then
	icon=""
	label="Not Connected"
	color="$GREY"
elif [[ -n "$vpn_name" ]]; then
	icon=""
	label="VPN"
	color="$GREEN"
else
	icon=""
	label="$ip_address"
	color="$BLUE"
fi

sketchybar --set network_label \
	icon="$icon" \
	label="$label" \
	background.color="$color" \
	--set _network background.border_color="$color"
