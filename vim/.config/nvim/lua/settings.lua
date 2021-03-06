local utils = require('utils')

local cmd = vim.cmd
local indent = 2

utils.opt('o', 'termguicolors', true)
utils.opt('b', 'expandtab', true)
utils.opt('b', 'shiftwidth', indent)
utils.opt('b', 'smartindent', true)
utils.opt('b', 'tabstop', indent)
utils.opt('o', 'hidden', true)
utils.opt('o', 'ignorecase', true)
utils.opt('o', 'scrolloff', 4 )
utils.opt('o', 'shiftround', true)
utils.opt('o', 'smartcase', true)
utils.opt('o', 'splitbelow', true)
utils.opt('o', 'splitright', true)
utils.opt('o', 'wildmode', 'list:longest')
utils.opt('w', 'number', true)
utils.opt('w', 'relativenumber', true)
utils.opt('w', 'numberwidth', 5)
utils.opt('w', 'foldmethod', 'expr')
utils.opt('w', 'foldexpr', 'nvim_treesitter#foldexpr()')
utils.opt('w', 'foldlevel', 5)
-- utils.opt('o', 'clipboard','unnamed,unnamedplus')
utils.opt('o', 'cmdheight', 1)
utils.opt('o', 'mouse','a')
utils.opt('o', 'showbreak','↪')
utils.opt('w', 'signcolumn', 'yes')

-- port over old configuration
vim.cmd [[
let g:python3_host_prog  = '/usr/local/bin/python3'
set t_ZH=[3m
set t_ZR=[23m
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

let maplocalleader = ','
syntax enable
filetype plugin indent on
set nowrap
set breakindent
set breakindentopt=sbr
set nofixendofline
set noswapfile
set encoding=UTF-8
set updatetime=300
set history=200

autocmd BufNewFile,BufRead *.ts set filetype=typescript
autocmd BufNewFile,BufRead *.tsx set filetype=typescriptreact

autocmd BufNewFile,BufRead *.js set filetype=javascript
autocmd BufNewFile,BufRead *.jsx set filetype=javascriptreact

set nrformats-=octal
]]

-- Highlight on yank
vim.cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'

vim.cmd [[
let g:closetag_regions = {'typescriptreact': 'jsxRegion,tsxRegion', 'javascriptreact': 'jsxRegion' }
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.tsx,*.jsx'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.tsx'
let g:closetag_filetypes = 'html,xhtml,phtml,javascriptreact,typescriptreact'
let g:closetag_xhtml_filetypes = 'xhtml,jsx,tsx'

let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_typescript = ['prettier']
let g:neoformat_enabled_typescriptreact = ['prettier']
let g:neoformat_enabled_lua = ['luaformat']
let g:neoformat_enabled_fish = ['fish_indent']
let g:neoformat_enabled_scss = ['prettier']
]]

-- quick-scope config
vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }

