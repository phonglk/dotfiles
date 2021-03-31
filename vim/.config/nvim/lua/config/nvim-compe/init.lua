local utils = require('utils')
local mp = require('utils.map')
local nmap, vmap, xmap, imap, smap, nnoremap, inoremap = mp.nmap, mp.vmap,
                                                         mp.xmap, mp.imap,
                                                         mp.smap, mp.nnoremap,
                                                         mp.inoremap

local npairs = require('nvim-autopairs')
vim.o.completeopt = "menuone,noselect"

require"compe".setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = "enable",
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,
    source = {
        vsnip = {priority = 10},
        nvim_lsp = {priority = 9},
        path = true,
        buffer = true,
        calc = true,
        -- nvim_lua = true,
        -- spell = true,
        -- tags = true,
        -- snippets_nvim = true,
        treesitter = {priority = 8}
        -- ultisnips = true,
        -- tabnine = true
    }
}

_G.completion_confirm = function()
    if vim.fn.pumvisible() ~= 0 then
        if vim.fn.complete_info()["selected"] ~= -1 then
            vim.fn["compe#confirm"]()
            return npairs.esc("")
        else
            vim.fn.nvim_select_popupmenu_item(0, false, false, {})
            vim.fn["compe#confirm"]()
            return npairs.esc("<c-n>")
        end
    else
        return npairs.check_break_line_char()
    end
end

_G.tab = function()
    if vim.fn.pumvisible() ~= 0 then
        return npairs.esc("<C-n>")
    else
        if vim.fn["vsnip#available"](1) ~= 0 then
            vim.fn.feedkeys(string.format('%c%c%c(vsnip-expand-or-jump)', 0x80,
                                          253, 83))
            return npairs.esc("")
        else
            return npairs.esc("<Tab>")
        end
    end
end

_G.s_tab = function()
    if vim.fn.pumvisible() ~= 0 then
        return npairs.esc("<C-p>")
    else
        if vim.fn["vsnip#jumpable"](-1) ~= 0 then
            vim.fn.feedkeys(string.format('%c%c%c(vsnip-jump-prev)', 0x80, 253,
                                          83))
            return npairs.esc("")
        else
            return npairs.esc("<C-h>")
        end
    end
end

-- vsnip
--
local G = require 'core.global'
vim.g["vsnip_snippet_dir"] = G.vim_path .. "snippets"

local opts = {expr = true}
xmap("<C-l>", "<Plug>(vsnip-select-text)")
xmap("<C-x>", "<Plug>(vsnip-cut-text)")

imap("<CR>", "v:lua.completion_confirm()", opts)
imap("<Tab>", "v:lua.tab()", opts)
imap("<S-Tab>", "v:lua.s_tab()", opts)

nnoremap('<Leader>cs', ':VsnipOpen<CR> 1<CR><CR>')
imap("<C-l>", "vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'",
     opts)
smap("<C-l>", "vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'",
     opts)
imap('<C-y>', "vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-space>'", opts)
smap('<C-y>', "vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-space>'", opts)

-- Compe
inoremap("<C-Space>", "compe#complete()", opts)
inoremap("<CR> ", "compe#confirm('<CR>')", opts)
inoremap("<C-e>", "compe#close('<C-e>')", opts)
inoremap("<C-f>", "compe#scroll({ 'delta': +4 })", opts)
inoremap("<C-d>", "compe#scroll({ 'delta': -4 })", opts)
