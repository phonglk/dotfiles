local status, _quotes = pcall(require, "vim-textobject-quotes")
if (not status) then return end

vim.keymap.set('x', 'q', 'iq', {})
vim.keymap.set('o', 'q', 'iq', {})
