function rename_workspace
  set curr (yabai -m query --spaces | jq -r '.[] | select (.focused == 1) | .label')
  set curr_idx (yabai -m query --spaces | jq -r '.[] | select (.focused == 1) | .index')
  set ans (osascript -e "display dialog \"Workspace [$curr_idx] name ?\" default answer \"$curr\"")
  set label (echo $ans | cut -d: -f3)
  yabai -m space $curr_idx --label "$label"
  osascript -e 'tell application "Übersicht" to refresh widget id "nibar-spaces-primary-jsx"'
end

