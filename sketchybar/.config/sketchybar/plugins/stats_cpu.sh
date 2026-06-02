#!/usr/bin/env bash

cpu=$(top -l 1 -n 0 -F 2>/dev/null | awk '
	/CPU usage/ {
		gsub("%", "", $3)
		gsub("%", "", $5)
		printf "%02.0f%%", $3 + $5
		exit
	}
')

sketchybar --set "$NAME" label="${cpu:---}"
