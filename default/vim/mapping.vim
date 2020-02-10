
let mapleader = ' ' 
map <C-j> <C-W>j
map <C-h> <C-W>h
map <C-k> <C-W>k
map <C-l> <C-W>l
noremap <C-y> "+y
noremap <C-p> "+p
tnoremap <Esc> <C-\><C-n>

nnoremap ,d :b#<bar>bd#<CR>
vmap <leader>F  <Plug>(coc-format-selected)
nnoremap <silent> <leader>t :NERDTreeToggle<CR>
nnoremap <silent> <leader>T :NERDTreeFind<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>l :BLines<CR>
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>s :Rg<CR>
nnoremap <silent> <leader>c :CocCommand<CR>
