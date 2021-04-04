local ts_config = require("nvim-treesitter.configs")

ts_config.setup {
    ensure_installed = {
        "javascript", "typescript", "tsx", "html", "css", "bash", "regex",
        "json", "jsdoc", "yaml", -- "cpp",
        -- "rust",
        "lua"
    },
    highlight = {enable = true, use_languagetree = true},
    refactor = {
        highlight_definitions = {enable = true},
        highlight_current_scope = {enable = true}
    },
    indent = {enable = true},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "tss",
            node_incremental = "tni",
            node_decremental = "tnd",
            scope_incremental = "tsi",
            scope_current = "tsc"
        }
    },
    rainbow = {enable = true},
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@conditional.outer",
                ["ic"] = "@conditional.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["ir"] = "@parameter.inner"
            }
        }
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?'
        }
    }
}
vim.cmd[[
nnoremap <F10> :TSHighlightCapturesUnderCursor<CR>
]]
