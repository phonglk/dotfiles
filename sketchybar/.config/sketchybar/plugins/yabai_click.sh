#!/bin/bash

space_number=$(yabai -m query --spaces --space | jq -r .index)
yabai_mode=$(yabai -m query --spaces --space | jq -r .type)
icon_mode=$(echo $NAME | cut -d"_" -f2)
echo "$(date):$space_number:$NAME:$icon_mode:$yabai_mode" >> ~/tmp/log.txt

sketchybar --set "yabai_bsp" icon.highlight="off"
sketchybar --set "yabai_float" icon.highlight="off"
sketchybar --set "yabai_stack" icon.highlight="off"

yabai -m space --layout $icon_mode
sketchybar --set "yabai_$icon_mode" icon.highlight="on"

