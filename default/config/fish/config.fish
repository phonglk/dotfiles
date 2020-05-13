set -g fish_user_paths "/usr/local/opt/protobuf@3.1/bin" $fish_user_paths
rvm default

alias cwd "pwd > /tmp/cwd"
alias pcwd "cat /tmp/cwd"
alias gwd "cd (pcwd)"

set -gx EDITOR nvim
