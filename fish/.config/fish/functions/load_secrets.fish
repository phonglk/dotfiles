function load_secrets
  for line in (env)
    set -l var (string split "=" -- $line)
    if string match -q 'op://*' -- $var[2]
      set -l command "set -gx $var[1] (op read \"$var[2]\")"
      echo $command
      eval $command
    end
  end
end

function gen_secrets_file
  # Create or truncate the _secrets.fish file
  echo "# Generated secrets file" > ~/.config/fish/_secrets.fish
  
  for line in (env)
    set -l var (string split "=" -- $line)
    if string match -q 'op://*' -- $var[2]
      set -l value (op read "$var[2]")
      set -l command "set -gx $var[1] \"$value\""
      echo $command >> ~/.config/fish/_secrets.fish
    end
  end
end
