vnoremap > >gv
vnoremap < <gv

let mapleader = "\<Space>"
let maplocalleader = ','
map <C-j> <C-W>j
map <C-h> <C-W>h
map <C-k> <C-W>k
map <C-l> <C-W>l
noremap <C-y> "+y
noremap <C-p> "+p
tnoremap <Esc> <C-\><C-n>

nnoremap ,d :b#<bar>bd#<CR>

" avoid open open file in tree pane
function! FZFOpen(command_str)
  if (expand('%') =~# 'NERD_tree' && winnr('$') > 1)
    exe "normal! \<c-w>\<c-w>"
  endif
  exe 'normal! ' . a:command_str . "\<cr>"
endfunction
nnoremap <silent> <leader>t :NERDTreeToggle<CR>
nnoremap <silent> <leader>T :NERDTreeFind<CR>
nnoremap <silent> <leader>b :call FZFOpen(':Buffers')<CR>
nnoremap <silent> <leader>l :call FZFOpen(':BLines')<CR>
nnoremap <silent> <leader>i :call FZFOpen(':Files')<CR>
nnoremap <silent> <leader>? :call FZFOpen(':History')<CR>
nnoremap <silent> <leader>s :call FZFOpen(':Rg')<CR>
nnoremap <silent> <leader>c :CocCommand<CR>
nnoremap <leader>u :UndotreeToggle<CR>
" map <C-A> <esc>ggVG<CR>

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
