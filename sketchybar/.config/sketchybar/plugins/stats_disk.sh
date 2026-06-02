#!/usr/bin/env bash

disk=$(df -H / 2>/dev/null | awk 'NR == 2 { print $5 }')

sketchybar --set "$NAME" label="${disk:---}"
