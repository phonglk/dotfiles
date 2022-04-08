
# tmux-batter
set -g @batt_icon_charge_tier8 '🌕'
set -g @batt_icon_charge_tier7 '🌖'
set -g @batt_icon_charge_tier6 '🌖'
set -g @batt_icon_charge_tier5 '🌗'
set -g @batt_icon_charge_tier4 '🌗'
set -g @batt_icon_charge_tier3 '🌘'
set -g @batt_icon_charge_tier2 '🌘'
set -g @batt_icon_charge_tier1 '🌑'
set -g @batt_icon_status_charged '🔋'
set -g @batt_icon_status_charging '⚡'
set -g @batt_icon_status_discharging '👎'
set -g @batt_color_status_primary_charged '#3daee9'
set -g @batt_color_status_primary_charging '#3daee9'

#theme
set -g @plugin 'o0th/tmux-nova'

set -g @nova-nerdfonts true
set -g @nova-nerdfonts-left 
set -g @nova-nerdfonts-right 

set -g "@nova-pane-active-border-style" "#44475a"
set -g "@nova-pane-border-style" "#282a36"
set -g "@nova-status-style-bg" "#4c566a"
set -g "@nova-status-style-fg" "#d8dee9"
set -g "@nova-status-style-active-bg" "#89c0d0"
set -g "@nova-status-style-active-fg" "#2e3540"
set -g "@nova-status-style-double-bg" "#2d3540"

set -g @nova-segment-mode "#{?client_prefix,R,N}"
set -g @nova-segment-mode-colors "#{?client_prefix,#e6db74,#50fa7b} #282a36"

set -g @nova-segment-sessionname "#S"
set -g @nova-segment-sessionname-colors "#fd971f #f8f8f2"

set -g @nova-segment-weather "#(weather_single_line)"
set -g @nova-segment-weather-colors "#fd971f #f8f8f2"

set -g @nova-segment-whoami "#(whoami)@#h"
set -g @nova-segment-whoami-colors "#50fa7b #282a36"

set -g @nova-pane " #I#{?pane_in_mode,  #{pane_mode},} #W"

set -g @nova-segment-spotify " #(spotifycli --status)"
set -g @nova-segment-spotify-colors "#282a36 #f8f8f2"

set -g @nova-segment-gitstatus " #(~/.tmux/plugins/tmux-simple-git-status/scripts/git_status.sh)"
set -g @nova-segment-gitstatus-colors "#282a36 #f8f8f2"

set -g @cpu_percentage_format "%5.1f%%"
set -g @nova-segment-cpu " #(~/.tmux/plugins/tmux-cpu/scripts/cpu_percentage.sh)"
set -g @nova-segment-cpu-colors "#282a36 #a6e22e"

# set -g @cpu_temp_unit "C"
# set -g @cpu_temp_format "%3.0f"
# set -g @nova-segment-cpu-temp "#(~/.tmux/plugins/tmux-cpu/scripts/cpu_temp.sh)"
# set -g @nova-segment-cpu-temp-colors "#282a36 #f8f8f2"
#
set -g @ram_percentage_format "%5.1f%%"
set -g @nova-segment-ram "#(~/.tmux/plugins/tmux-cpu/scripts/ram_percentage.sh)"
set -g @nova-segment-ram-colors "#282a36 #a1efe4"

# set -g @gpu_percentage_format "%5.1f%%"
# set -g @nova-segment-gpu "﬙ #(~/.tmux/plugins/tmux-cpu/scripts/gpu_percentage.sh)"
# set -g @nova-segment-gpu-colors "#282a36 #f8f8f2"
#
# set -g @gpu_temp_unit "C"
# set -g @gpu_temp_format "%3.0f"
# set -g @nova-segment-gpu-temp "#(~/.tmux/plugins/tmux-cpu/scripts/gpu_temp.sh)"
# set -g @nova-segment-gpu-temp-colors "#282a36 #f8f8f2"
#
# set -g @gram_percentage_format "%5.1f%%"
# set -g @nova-segment-gram "#(~/.tmux/plugins/tmux-cpu/scripts/gram_percentage.sh)"
# set -g @nova-segment-gram-colors "#282a36 #f8f8f2"

set -g @net_speed_interfaces "en0"
set -g @net_speed_format " %7s  祝 %7s"
set -g @nova-segment-net "#(~/.tmux/plugins/tmux-net-speed/scripts/net_speed.sh)"
set -g @nova-segment-net-colors "#ae81ff #f8f8f2"

set -g @nova-segment-pomodoro "#(pomodoro status --format ' %%c  %%r %%d') "
set -g @nova-segment-pomodoro-colors "#ff5555 #f8f8f2"

set -g @nova-rows 1
set -g @nova-segments-0-left "mode"
set -g @nova-segments-0-right "sessionname whoami pomodoro"
set -g @nova-segments-1-left "gitstatus"
set -g @nova-segments-1-right "cpu ram net"


# Pomodoro
# Options
set -g @pomodoro_start 'p'                          # Start a Pomodoro with tmux-prefix + p
set -g @pomodoro_cancel 'P'                         # Cancel a Pomodoro with tmux-prefix key + P

set -g @pomodoro_mins 25                            # The duration of the pomodoro
set -g @pomodoro_break_mins 5                       # The duration of the break after the pomodoro

set -g @pomodoro_on " #[fg=$text_red]🍅 "           # The formatted output when the pomodoro is running
set -g @pomodoro_complete " #[fg=$text_green]🍅 "   # The formatted output when the break is running

set -g @pomodoro_notifications 'on'                 # Turn on/off desktop notifications
set -g @pomodoro_sound 'Pop'                        # Sound for desktop notifications (Run `ls /System/Library/Sounds` for a list of sounds to use)


# nhdaly/tmux-better-mouse-mode
set -g @scroll-down-exit-copy-mode "off"
set -g @scroll-speed-num-lines-per-scroll "1"
set -g @scroll-without-changing-pane "on"

# tmux-continuum
set -g @continuum-restore 'on'

set -g @tmux_window_name_shells "['zsh', 'bash', 'sh', 'fish']"
