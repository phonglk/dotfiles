local utils = require('utils')
local map = utils.map

-- Map leader to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.pastetoggle = '<F3>'
-- indent
map('v', '>', '>gv')
map('v', '<', '<gv')

-- copy & paste from clipboard
map('v', '<C-y>', [["+y]])
map('n', '<C-p>', [["+p]])
map('v', '<C-p>', [["+p]])

-- move between panels
-- map('', '<C-j>', '<C-W>j')
-- map('', '<C-h>', '<C-W>h')
-- map('', '<C-k>', '<C-W>k')
-- map('', '<C-l>', '<C-W>l')

-- display line vs realline
map('n', 'k', 'gk')
map('n', 'gk', 'k')
map('n', 'j', 'gj')
map('n', 'gj', 'j')

-- select scope
map('n', 'sx', 'tsstsi', {noremap = false})
map('v', 'sx', 'tsi', {noremap = false})

-- text text-object-quote
map('x', 'q', 'iq', {noremap = false})
map('o', 'q', 'iq', {noremap = false})

-- esc
map('t', '<Esc>', [[<C-\><C-n>]])

-- clear highlight
map('n', '<C-l>', ':<C-u>nohlsearch<CR><C-l>')

-- toggle wrap
map('n', '<M-w>', ':set wrap!<CR>')

-- delete current buffer
map('n', '<leader>db', ':bd<CR>')

-- replace and search under cursor
map('v', '/R', [[y:%s/<C-R>=escape(@",'/\')<CR>//g<left><left>]])
map('v', '/r', [[y:s/<C-R>=escape(@",'/\')<CR>//g<left><left>]])
map('v', '//', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])

-- edit relative files
map('n', '<leader>o', ':e %:h')
map('c', '%%', "getcmdtype() == ':' ? expand('%:h').'/' : '%%'")

-- Neoformat
map('x', '<leader>ff', ':Neoformat<CR>')
map('v', '<leader>ff', ':Neoformat<CR>')
map('n', '<leader>ff', ':Neoformat<CR>')

-- delete without yanking
map('n', "<localleader>d", '"_d')
map('v', "<localleader>d", '"_d')
map('n', "<localleader>D", '"_D')
map('v', "<localleader>D", '"_D')
-- replace currently selected text with default register
map('n', "<localleader>p", '"_dP')
map('v', "<localleader>p", '"_dP')

map('n', "<localleader>c", '"_dc')
map('v', "<localleader>c", '"_dc')
map('n', "<localleader>C", '"_dC')
map('v', "<localleader>C", '"_dC')
map('n', "gV", "`[v`]")

vim.api.nvim_exec([[
augroup vimrcQfClose
    autocmd!
    autocmd FileType qf if mapcheck('<esc>', 'n') ==# '' | nnoremap <buffer><silent> <esc> :cclose<bar>lclose<CR> | endif
augroup END
]], false)
