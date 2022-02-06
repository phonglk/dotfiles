local global = require("core.global")
local lsp_settings = require("lsp.global")

require"lspconfig".tsserver.setup {
    cmd = {
        global.lsp_path ..
            "lspinstall/typescript/node_modules/.bin/typescript-language-server",
        "--stdio"
    },
    on_attach = function(client)
        if not packer_plugins["lsp_signature.nvim"].loaded then
            vim.cmd [[packadd lsp_signature.nvim]]
        end
        require"lsp_signature".on_attach(lsp_settings.signature_cfg)
        lsp_settings.documentHighlight(client)

        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup {
            debug = false,
            disable_commands = false,
            enable_import_on_completion = false,
            import_on_completion_timeout = 5000,
            -- eslint
            eslint_enable_code_actions = true,
            eslint_bin = "eslint",
            eslint_args = {
                "-f", "json", "--stdin", "--stdin-filename", "$FILENAME"
            },
            eslint_enable_disable_comments = true,
            -- experimental settings!
            -- eslint diagnostics
            eslint_enable_diagnostics = false,
            eslint_diagnostics_debounce = 250,
            -- formatting
            enable_formatting = false,
            formatter = "prettier",
            formatter_args = {"--stdin-filepath", "$FILENAME"},
            format_on_save = false,
            no_save_after_format = false,
            -- parentheses completion
            complete_parens = false,
            signature_help_in_parens = false,
            -- update imports on file move
            update_imports_on_move = false,
            require_confirmation_on_move = false,
            watch_dir = "/src"
        }
        -- required to enable ESLint code actions and formatting
        ts_utils.setup_client(client)
    end,
    root_dir = require("lspconfig/util").root_pattern("."),
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic
                                                               .on_publish_diagnostics,
                                                           lsp_settings.diagnostics_cfg)
    }
}
