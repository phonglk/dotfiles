set shell=bash

if has('nvim')
	source ~/.vim/nvim.vim
endif

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')
    " {{{ Assist
        " {{{ Autoclosing
        Plug 'ntpeters/vim-better-whitespace'
        Plug 'jiangmiao/auto-pairs'
        Plug 'alvan/vim-closetag'
        " }}}
        " {{{ Syntax
        Plug 'tomtom/tcomment_vim'
        Plug 'tommcdo/vim-lion'
        " }}}
        " {{{ Navigation
        Plug 'easymotion/vim-easymotion'
        Plug 'junegunn/vim-peekaboo'
        Plug 'unblevable/quick-scope'
	" }}
	" }}}

    " {{{ Languages
        " {{{ Text Object
        Plug 'machakann/vim-sandwich'
        Plug 'machakann/vim-highlightedyank'
        Plug 'kana/vim-textobj-user'
        Plug 'kana/vim-textobj-entire'
        Plug 'beloglazov/vim-textobj-quotes'
        " }}}
        " {{{ Async
        Plug 'tpope/vim-dispatch'
        " }}}
    " }}}

    " {{{ UI
        " {{{ Colorschemes
        Plug 'AlessandroYorba/alduin'
        Plug 'morhetz/gruvbox'
        Plug 'arzg/vim-substrata'
        Plug 'crusoexia/vim-monokai'
        Plug 'patstockwell/vim-monokai-tasty'
        " }}}
    " }}}
    Plug 'Raimondi/delimitMate'
    " devicons
    Plug 'ryanoasis/vim-devicons'
    Plug 'vwxyutarooo/nerdtree-devicons-syntax'
call plug#end()

" vim: foldmethod=marker:foldlevel=1
" Config
let NERDTreeShowHidden=1
set cmdheight=2
set foldmethod=indent
set foldlevel=10
set tabstop=2 shiftwidth=2 expandtab
set mouse=a
set number
set smartcase
set ignorecase
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

let g:python_host_prog = '/usr/local/Cellar/python/3.7.7/bin/python3'
let g:python3_host_prog = '/usr/local/Cellar/python/3.7.7/bin/python3'

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

" Mapping
vnoremap > >gv
vnoremap < <gv

let mapleader = "\<Space>"
let maplocalleader = ','
map <C-j> <C-W>j
map <C-h> <C-W>h
map <C-k> <C-W>k
map <C-l> <C-W>l
"
" display line vs real line
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

noremap ,y "+y
noremap ,p "+p
tnoremap <Esc> <C-\><C-n>

nnoremap ,d :b#<bar>bd#<CR>

" avoid open open file in tree pane
function! FZFOpen(command_str)
  if (expand('%') =~# 'NERD_tree' && winnr('$') > 1)
    exe "normal! \<c-w>\<c-w>"
  endif
  exe 'normal! ' . a:command_str . "\<cr>"
endfunction

nnoremap <leader>u :UndotreeToggle<CR>
" map <C-A> <esc>ggVG<CR>

" Search under cursor
vnoremap /R y:%s/<C-R>=escape(@",'/\')<CR>//g<left><left>
vnoremap /r y:s/<C-R>=escape(@",'/\')<CR>//g<left><left>
" Search under cursor
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
" {{{ vim-easymotion
  let g:EasyMotion_do_mapping = 0
  " nmap s <Plug>(easymotion-overwin-f)
  " or
  " `s{char}{char}{label}`
  " Need one more keystroke, but on average, it may be more comfortable.
  " nmap s <Plug>(easymotion-overwin-f2)

  " Turn on case-insensitive feature
  let g:EasyMotion_smartcase = 1
  " Move to line
  map <Leader>L <Plug>(easymotion-bd-jk)
  nmap <Leader>L <Plug>(easymotion-overwin-line)

  " Move to word
  map  <Leader>w <Plug>(easymotion-bd-w)
  nmap <Leader>w <Plug>(easymotion-overwin-w)
  " hjkl
  map <Leader>l <Plug>(easymotion-lineforward)
  map <Leader>j <Plug>(easymotion-j)
  map <Leader>k <Plug>(easymotion-k)
  map <Leader>h <Plug>(easymotion-linebackward)
  let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
" }}}
" Remap for format selected region
xmap <leader>ff  <Plug>(coc-format-selected)
vmap <leader>ff  <Plug>(coc-format-selected)
" autofix eslint
xmap <leader>fe  :CocCommand eslint.executeAutofix<CR>
vmap <leader>fe  :CocCommand eslint.executeAutofix<CR>
nmap <leader>fe  :CocCommand eslint.executeAutofix<CR>

nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" configuration for text-object-quote
xmap q iq
omap q iq

" toggle wrap
nmap <M-w> :set wrap!<CR>

" edit relative files
nnoremap <leader>o :e %:h
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

set pastetoggle=<F3>

" command! ReSource source ~/.vimrc
command! CopyRelativePath :let @+=expand("%")

" specific to vscode-neovim
" set clipboard=unnamedplus
" Comment
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine
" LSP
nmap gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
nmap gd <Cmd>call VSCodeNotify('editor.action.peekDefinition')<CR>
nmap gD <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
nmap gs <Cmd>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>
nmap grn <Cmd>call VSCodeNotify('editor.action.rename')<CR>
nmap ]g <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
nmap [g <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>

" fold
nmap zM <Cmd>call VSCodeNotify('editor.foldAll')<CR>
nmap zR <Cmd>call VSCodeNotify('editor.unfoldAll')<CR>
nmap zo <Cmd>call VSCodeNotify('editor.unfold')<CR>
nmap zO <Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>
nmap zc <Cmd>call VSCodeNotify('editor.fold')<CR>
nmap zC <Cmd>call VSCodeNotify('editor.foldRecursively')<CR>
nmap za <Cmd>call VSCodeNotify('editor.toggleFold')<CR>

nmap za <Cmd>call VSCodeNotify('editor.toggleFold')<CR>

nmap <leader>t <Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>

set exrc
set secure
