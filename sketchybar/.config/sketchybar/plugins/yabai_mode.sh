#!/bin/bash

space_number=$(yabai -m query --spaces --space | jq -r .index)
yabai_mode=$(yabai -m query --spaces --space | jq -r .type)
icon_mode=$(echo $NAME | cut -d"_" -f2)
# echo "$(date):$space_number:$NAME:$icon_mode:$yabai_mode" >> ~/tmp/log.txt

if [ "$icon_mode" = "$yabai_mode" ]; then
  sketchybar --set "$NAME" icon.highlight="on"
else
  sketchybar --set "$NAME" icon.highlight="off"
fi
