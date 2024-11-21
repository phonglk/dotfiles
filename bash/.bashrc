# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$HOME/bin"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
EDITOR=nvim
alias python='/usr/local/Cellar/python/3.7.7/bin/python3'
alias jsb='~/.nvm/versions/node/v14.3.0/bin/js-beautify'
eval "$(fnm env --use-on-cd)"
export OPEN_WEATHER_API_KEY="42cd4786837d0afce2c7dc5814c65244"
# CoderEnv
# DO NOT EDIT: Added by Coder CLI installer (https://coder.canva-internal.com/install.sh)
[ -e "/Users/phongle/.coder.sh" ] && . "/Users/phongle/.coder.sh"
# EndCoderEnv
