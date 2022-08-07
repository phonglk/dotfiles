function change_workspace_padding
  set ans (osascript -e "display dialog \"Workspace [$curr_idx] padding ?\" default answer \"25 5 5 5\"")
  set padding (echo $ans | cut -d: -f3 | sed 's/ /:/g')
  yabai -m space $curr_idx --padding abs:$padding
end

