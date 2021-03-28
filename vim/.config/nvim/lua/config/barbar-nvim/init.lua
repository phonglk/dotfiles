local utils = require('utils')
local map = utils.map

-- Navigate
map('n', '<M-,>', ':BufferPrevious<CR>')
map('n', '<M-.>', ':BufferNext<CR>')
-- Shifting around
map('n', '<M-<>', ':BufferMovePrevious<CR>')
map('n', '<M->>', ':BufferMoveNext<CR>')
-- Close
map('n', '<M-c>', ':BufferClose<CR>')
map('n', '<M-C>', ':BufferCloseAllButCurrent<CR>')
-- Pick by name
map('n', '<M-p>', ':BufferPick<CR>')
