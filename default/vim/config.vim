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
set nofixendofline
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

let g:polyglot_disabled = ['javascript', 'typescript', 'jsx', 'graphql']
let g:startify_session_dir = '~/.vim/session'
set relativenumber
let g:fzf_preview_window = 'down:40%'
let g:fzf_layout = { 'window': {'width': 0.9, 'height': 0.9} }
" command! -bang -nargs=* Rg call fzf#vim#grep(
"   \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
"   \   fzf#vim#with_preview({'window': {'width': 0.9, 'height': 0.9}}, 'down:40%'), <bang>0)
" To have local bookmarks for NERDTree
if isdirectory(expand(".git"))
  let g:NERDTreeBookmarksFile = '.git/.nerdtree-bookmarks'
endif
