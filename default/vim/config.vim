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
set noswapfile
set encoding=UTF-8
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
