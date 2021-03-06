if status --is-interactive
  set -g fish_user_paths "/usr/local/opt/protobuf@3.1/bin" "$HOME/bin" $fish_user_paths
  alias dotfiles '/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
  if type -q $rvm
  	rvm default
  end

  alias wdsave "pwd >> ~/.wdsave && tail -n 5 ~/.wdsave > ~/.wdsavetmp && mv ~/.wdsavetmp ~/.wdsave"
  # alias pcwd "cat /tmp/cwd"
  alias wdload "cd (tail -r ~/.wdsave | fzf)"
  alias python "/usr/local/Cellar/python/3.7.7/bin/python3"
  alias .. "cd ../"
  alias ... "cd ../../"
  alias .... "cd ../../../"
  # alias jsb "~/.nvm/versions/node/v14.3.0/bin/js-beautify"
  alias tmux "tmux -2"
  alias gitwtgo 'cd (git worktree list | fzf | cut -d" " -f 1)'
  alias cdb 'cd (cat ~/.bookmarks | fzf)'

  set -gx EDITOR nvim
  set -gx PAGER most

  # uses dircolors template
  switch (uname)
    case Darwin
      eval (gdircolors -c ~/.dircolors/dircolors.256dark)
    case Linux
      eval (dircolors ~/.dircolors/nord | sed 's/=/ /; s/\'/"/g; s/;\n//g' | awk '{print "set -x " $0}' | head -n 1)
  end

  # Aliases
  if type -q gls
    alias ls='gls --color=auto'
  else
    switch (uname)
      case Darwin
        alias ls='ls -G'
      case Linux
        alias ls='ls --color=auto'
    end
  end
  alias ll='ls -lah'

  abbr -a -g gpsuo git push --set-upstream origin
  abbr -a -g gpsuoc "git push --set-upstream origin (git branch --show-current)"
  abbr -a -g gco git checkout
  abbr -a -g gcm git commit -m "
  abbr -a -g gcam git commit -am "

  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
  # Auto start tmux
  # if status is-interactive 
  # and not set -q TMUX
  #   tmux attach -t default || tmux new -s default
  # end
  # clear
end

set -g -x FISH_HELPER_PATH '/Users/phonglk/source/shopee/dl-helper/jira-helper'
fish_helper
