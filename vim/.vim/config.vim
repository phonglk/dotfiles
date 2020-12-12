let NERDTreeShowHidden=1
let $FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
set cmdheight=2
set foldmethod=indent
set tabstop=2 shiftwidth=2 expandtab
set mouse=a
set number
set relativenumber
set numberwidth=5
hi CursorLineNR cterm=bold ctermbg=NONE ctermfg=red
set nowrap
set breakindent
set breakindentopt=sbr
set nofixendofline
set noswapfile
set encoding=UTF-8
set hidden
set updatetime=300
set history=200
set wildmode=longest,list
" I use a unicode curly array with a <backslash><space>
set showbreak=↪>\

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
set t_Co=256
syntax enable

let g:vim_monokai_tasty_italic = 1
colorscheme vim-monokai-tasty
let g:lightline = {
      \ 'colorscheme': 'monokai_tasty',
      \ }

augroup SyntaxSettings
    autocmd!
    autocmd BufNewFile,BufRead *.tsx set filetype=typescript
augroup END

let g:startify_session_dir = '~/.vim/session'
let g:fzf_preview_window = 'down:40%'
let g:fzf_layout = { 'window': {'width': 0.9, 'height': 0.9} }

let g:python_host_prog = '/usr/local/Cellar/python/3.7.7/bin/python3'
let g:python3_host_prog = '/usr/local/Cellar/python/3.7.7/bin/python3'
if isdirectory(expand(".git"))
  let g:NERDTreeBookmarksFile = '.git/.nerdtree-bookmarks'
endif

" :BD to clear buffers
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))


let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1
let g:webdevicons_enable_startify = 1

" Plug quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" exclude octal
set nrformats-=octal

source ~/.vim/nerdtree.vim
" source ~/.vim/lsp.vim
source ~/.vim/coc_config.vim

