" {{{ LSP Server Configuration
  " {{{ ESLint language Server
  if filereadable(glob('~/.vim/lsp-servers/bin/eslint-language-server'))
    au User lsp_setup call lsp#register_server({
    \ 'name': 'eslint-language-server',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, '~/.vim/lsp-servers/bin/eslint-language-server --stdio']},
    \ 'whitelist': ['javascript', 'javascript.jsx', 'typescript'],
    \ 'initialization_options': { 'diagnostic': 'true' },
    \ 'workspace_config': {
    \   'validate': 'probe',
    \   'packageManager': 'npm',
    \   'codeActionOnSave': {
    \     'enable': v:true,
    \     'mode': 'all',
    \   },
    \   'codeAction': {
    \     'disableRuleComment': {
    \       'enable': v:true,
    \       'location': 'separateLine',
    \     },
    \     'showDocumentation': {
    \       'enable': v:true,
    \     },
    \   },
    \   'format': v:false,
    \   'quiet': v:false,
    \   'onIgnoredFiles': 'off',
    \   'options': {},
    \   'run': 'onType',
    \   'nodePath': v:null,
    \ },
    \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
    \ })
  endif
  " }}}
  " {{{ Typescript language server
  if filereadable(glob('~/.vim/lsp-servers/bin/typescript-language-server'))
    au User lsp_setup call lsp#register_server({
    \ 'name': 'typescript-language-server',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, '~/.vim/lsp-servers/bin/typescript-language-server --stdio']},
    \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
    \ 'whitelist': ['javascript', 'javascript.jsx', 'typescript', 'typescript.jsx'],
    \ })
  endif
  " }}}
" }}}

" {{{ Other LSP Configuration
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  " nmap <buffer> gd <plug>(lsp-definition)
  nmap gd <Plug>(lsp-definition)
  nmap gv :vsplit<CR><Plug>(lsp-definition)
  nmap gs :split<CR><Plug>(lsp-definition)
  nmap gr :LspReferences<CR>
  nmap ga :LspCodeAction<CR>
  nmap K <Plug>(lsp-hover)
  nmap rn <Plug>(lsp-rename)
  nmap gp <Plug>(lsp-peek-definition)
  nmap ,n <plug>(lsp-next-diagnostic)
  nmap ,p <plug>(lsp-previous-diagnostic)
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_virtual_text_enabled = 0
let g:lsp_highlight_references_enabled = 1

" highlight LspWarningHighlight cterm=underline,bold
" highlight LspErrorHighlight guibg=orange
" highlight LspHintHighlight guifg=yellow
" highlight lspReference guifg=red guibg=green

let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '⚠'}
let g:lsp_signs_hint = {'text' : '✓'}
let g:lsp_signs_information = {'text' : 'ℹ'}
" }}}

" {{{ Autocomplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)

let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'blacklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))
" }}}

" {{{ Debug
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')
" }}}
