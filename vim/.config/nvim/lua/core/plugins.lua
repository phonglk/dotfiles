local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

return require('lazy').setup({
  {
    'nvim-telescope/telescope.nvim', version = '0.1.1',
    dependencies = { { 'nvim-lua/plenary.nvim' } }
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', config = function()
    require('telescope').load_extension('fzf')
  end },
  {
    "princejoogie/dir-telescope.nvim",
    -- telescope.nvim is a required dependency
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("dir-telescope").setup({
        hidden = true,
        respect_gitignore = true,
      })
    end,
  },
  {
    'nvim-telescope/telescope-file-browser.nvim',
    config = function()
      require('telescope').load_extension('file_browser')
      vim.api.nvim_set_keymap(
        "n",
        "<leader>fb",
        ":Telescope file_browser",
        { noremap = true }
      )
    end
  },
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        actions = {
          change_dir = {
            global = true,
          },
          open_file = {
            resize_window = false,
          }
        }
      })
      vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>T", "<cmd>NvimTreeFindFile<cr>", { noremap = true, silent = true })
    end,
  },
  'ofirgall/ofirkai.nvim', -- better monokai
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require("rose-pine").setup()
      vim.cmd('colorscheme rose-pine')
    end
  },

  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  'nvim-treesitter/nvim-treesitter-context',
  'nvim-treesitter/playground',
  'ThePrimeagen/harpoon',
  'tpope/vim-fugitive',
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      { 'williamboman/mason.nvim' }, -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' }, -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'hrsh7th/cmp-buffer' }, -- Optional
      { 'hrsh7th/cmp-path' }, -- Optional
      { 'saadparwaiz1/cmp_luasnip' }, -- Optional
      { 'hrsh7th/cmp-nvim-lua' }, -- Optional

      -- Snippets
      { 'L3MON4D3/LuaSnip' }, -- Required
      { 'rafamadriz/friendly-snippets' }, -- Optional

    },
  },
  {
    'jose-elias-alvarez/null-ls.nvim'
  },
  {
    'MunifTanjim/prettier.nvim'
  },
  -- vscode-like pictogram
  { 'onsails/lspkind-nvim', config = function()
    local lspkind = require('lspkind');
    lspkind.init({
      -- enables text annotations
      --
      -- default: true
      mode = 'symbol',

      -- default symbol map
      -- can be either 'default' (requires nerd-fonts font) or
      -- 'codicons' for codicon preset (requires vscode-codicons font)
      --
      -- default: 'default'
      preset = 'codicons',

      -- override preset symbols
      --
      -- default: {}
      symbol_map = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "ﰠ",
        Variable = "",
        Class = "ﴯ",
        Interface = "",
        Module = "",
        Property = "ﰠ",
        Unit = "塞",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "פּ",
        Event = "",
        Operator = "",
        TypeParameter = ""
      },
    })
  end },
  {
    'lukas-reineke/lsp-format.nvim',
    config = function()
      require("lsp-format").setup {}
    end
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({ text = { spinner = "meter" }, timer = { spinner_rate = 100 } })
    end,
  },
  {
    'windwp/nvim-autopairs', config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt", "vim" }
      })
    end,
  },
  'machakann/vim-sandwich',
  { 'beloglazov/vim-textobj-quotes', dependencies = { 'kana/vim-textobj-user' } },
  { 'David-Kunz/jester', config = function()
    local jester = require('jester')
    jester.setup({
      path_to_jest_run = "yarn jest"
    })
    vim.keymap.set("n", "<leader>jr", function() jester.run() end)
    vim.keymap.set("n", "<leader>jf", function() jester.run_file() end)
  end },
  {
    'phaazon/hop.nvim',
    config = function()
      local hop = require('hop')
      hop.setup({ key = 'etovxpqdgfblzhckisuran' })
      vim.keymap.set('', '<leader>hw', ':HopWordAC<CR>', { remap = true })
      vim.keymap.set('', '<leader>hW', ':HopWordBC<CR>', { remap = true })
      vim.keymap.set('', '<leader>hj', ':HopLineAC<CR>', { remap = true })
      vim.keymap.set('', '<leader>hk', ':HopLineBC<CR>', { remap = true })
      vim.keymap.set('', '<leader>Hw', ':HopWordMW<CR>', { remap = true })
      vim.keymap.set('', '<leader>Hl', ':HopLineMW<CR>', { remap = true })
    end
  },
  {
    'olimorris/persisted.nvim',
    config = function()
      require("persisted").setup({
        use_git_branch = true,
      })
      require("telescope").load_extension("persisted") -- To load the telescope extension
    end
  }
})
