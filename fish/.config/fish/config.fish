if status --is-interactive
  set -g fish_user_paths "/usr/local/opt/protobuf@3.1/bin" $fish_user_paths
  alias dotfiles '/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
  rvm default

  alias cwd "pwd > /tmp/cwd"
  alias pcwd "cat /tmp/cwd"
  alias gwd "cd (pcwd)"

  set -gx EDITOR nvim
  set -gx PAGER most

  # uses dircolors template
  eval (gdircolors ~/.dircolors/nord | sed 's/=/ /; s/\'/"/g; s/;\n//g' | awk '{print "set -x " $0}' | head -n 1)

  # Aliases
  alias ls='gls --color=auto'
  alias ll='ls -lah'

  # Auto start tmux
  # if status is-interactive 
  # and not set -q TMUX
  #   tmux attach -t default || tmux new -s default
  # end
  # clear
end

