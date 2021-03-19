local ts_config = require("nvim-treesitter.configs")

--[[ Scripts to install manually 
--local langs = {"javascript", "typescript", "tsx", "html", "css", "bash", "regex", "json", "jsdoc", "yaml", "lua" }
for _, lang in ipairs(langs) do
  vim.api.nvim_command('TSInstallFromGrammar '..lang)
end]
--]]

ts_config.setup {
    ensure_installed = {
        -- https://www.reddit.com/r/neovim/comments/m4f6rv/fix_for_treesitter_abi_version_mismatch_in_neovim/
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "bash",
        "regex",
        "json",
        "jsdoc",
        "yaml",
        -- "cpp",
        -- "rust",
        "lua"
    },
    highlight = {
      enable = true,
      use_languagetree = true
    },
    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = true },
    },
    rainbow = {
      enable = true
    }
  }
