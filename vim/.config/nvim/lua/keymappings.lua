local utils = require('utils')
local map = utils.map

vim.g.pastetoggle='<F3>'
-- indent
map('v', '>', '>gv')
map('v', '<', '<gv')

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

-- text text-object-quote
map('x', 'q', 'iq')
map('o', 'q', 'iq')

-- esc
map('t', '<Esc>', [[<C-\><C-n>]])

-- clear highlight
map('n', '<C-l>', ':<C-u>nohlsearch<CR><C-l>')

-- toggle wrap
map('n', '<M-w>', ':set wrap!<CR>')

-- delete current buffer
map('n', '<leader>db', ':bd<CR>')

-- replace and search under cursor
map ('v', '/R', [[y:%s/<C-R>=escape(@",'/\')<CR>//g<left><left>]])
map ('v', '/r', [[y:s/<C-R>=escape(@",'/\')<CR>//g<left><left>]])
map ('v', '//', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])

-- edit relative files
map('n', '<leader>o', ':e %:h')
map('c', '%%', "getcmdtype() == ':' ? expand('%:h').'/' : '%%'")
