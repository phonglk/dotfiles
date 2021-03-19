function codi --description "Coding scratch pad"
  set syntax "$1"
  test -z "$syntax"; and set syntax "javascript"
  set --erase argv[1]
  nvim -c \
    "let g:startify_disable_at_vimenter = 1 |\
    set bt=nofile ls=0 noru nonu nornu |\
    hi ColorColumn ctermbg=NONE |\
    hi VertSplit ctermbg=NONE |\
    hi NonText ctermfg=0 |\
    Codi $syntax" "$argv"
end
