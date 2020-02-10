let NERDTreeShowHidden=1
let $FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
set cmdheight=2
set foldmethod=indent
set tabstop=2 shiftwidth=2 expandtab
set mouse=a
set number
set nowrap
set breakindent
set breakindentopt=sbr
" I use a unicode curly array with a <backslash><space>
set showbreak=↪>\
source ~/.vim/coc_config.vim
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
set t_Co=256
syntax enable
colorscheme monokai
augroup SyntaxSettings
    autocmd!
    autocmd BufNewFile,BufRead *.tsx set filetype=typescript
augroup END
