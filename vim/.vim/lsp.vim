" {{{ LSP Configuration
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
  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> <f2> <plug>(lsp-rename)
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" }}}
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')
