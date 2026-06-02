#!/usr/bin/env bash

memory=$(memory_pressure 2>/dev/null | awk '
	/System-wide memory free percentage:/ {
		gsub("%", "", $5)
		printf "%02.0f%%", 100 - $5
		exit
	}
')

sketchybar --set "$NAME" label="${memory:---}"
