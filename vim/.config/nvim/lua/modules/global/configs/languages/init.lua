local config = {}

function config.lsp()
    local servers = {
        'bash', 'cpp', 'css', 'dart', 'docker', 'elixir', 'go', 'graphql',
        'html', 'java', 'js-ts', 'json', 'latex', 'lua', 'omnisharp', 'php',
        'python', 'ruby', 'rust', 'svelte', 'vim', 'yaml'
    }
    for _, server in ipairs(servers) do
        local settins = {lsp_config = "lsp.global.languages." .. server}
        require(settins.lsp_config)
    end
end

function config.dart()
    if not packer_plugins["plenary.nvim"].loaded then
        vim.cmd [[packadd plenary.nvim]]
    end
    require("flutter-tools").setup {}
end

function config.treesitter()
    if not packer_plugins["playground"].loaded then
        vim.cmd [[packadd playground]]
    end
    require"nvim-treesitter.configs".setup {
        ensure_installed = "all",
        ignore_install = {"haskell"},
        highlight = {enable = true},
        indent = {enable = {"javascriptreact"}},
        playground = {
            enable = true,
            disable = {},
            updatetime = 25,
            persist_queries = false,
            keybindings = {
                toggle_query_editor = "o",
                toggle_hl_groups = "i",
                toggle_injected_languages = "t",
                toggle_anonymous_nodes = "a",
                toggle_language_display = "I",
                focus_language = "f",
                unfocus_language = "F",
                update = "R",
                goto_node = "<cr>",
                show_help = "?"
            }
        },
        autotag = {enable = true},
        rainbow = {enable = true},
        context_commentstring = {
            enable = true,
            config = {javascriptreact = {style_element = "{/*%s*/}"}}
        }
    }
end

function config.jump()
    vim.cmd([[unmap <leader>j]])
    vim.g.any_jump_disable_default_keybindings = 1
    vim.g.any_jump_list_numbers = 1
end

function config.trouble()
    require("trouble").setup {
        height = 12,
        mode = "lsp_document_diagnostics",
        use_lsp_diagnostic_signs = true,
        action_keys = {
            refresh = "r",
            toggle_mode = "m",
            toggle_preview = "P",
            close_folds = "zc",
            open_folds = "zo",
            toggle_fold = "zt"
        }
    }
end

function config.symbols()
    require("symbols-outline").setup {
        highlight_hovered_item = true,
        show_guides = true
    }
end

function config.dependency() require"dependency_assist".setup {} end

return config
