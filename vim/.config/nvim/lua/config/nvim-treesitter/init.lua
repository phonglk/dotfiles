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
                ["ir"] = "@parameter.inner",
            }
        }
    }
}
