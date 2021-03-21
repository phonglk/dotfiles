function nice_find_and_set -d "Find the process by name and set nice"
  set process $argv[1]
  set value $argv[2]
  echo "$process -> $value"
  ps -ef | grep $argv[1] | grep -v grep | awk '{print $2}' | xargs sudo renice $argv[2]
end

function nice_adjust -d "My preset for adjusting nice"
  nice_find_and_set falcond -19
  nice_find_and_set yabai 1
  nice_find_and_set skhd 1
  nice_find_and_set limelight -10
end
