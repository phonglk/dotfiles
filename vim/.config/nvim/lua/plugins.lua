return require('packer').startup(function()

  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}

  -- Color scheme
  use { 'sainnhe/gruvbox-material' }
  use { 'Th3Whit3Wolf/one-nvim' }
  use { 'patstockwell/vim-monokai-tasty' }
  use { 'Iron-E/nvim-highlite'}

  -- Fuzzy finder
  use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  -- LSP and completion
  use { 'neovim/nvim-lspconfig' }
  use { 'onsails/lspkind-nvim' }
  use { 'anott03/nvim-lspinstall' }
  use { 'nvim-lua/completion-nvim' }
  use { 'hrsh7th/nvim-compe' }

  -- Lua development
  use { 'tjdevries/nlua.nvim' }


  -- Vim dispatch
  use { 'tpope/vim-dispatch' }

  -- Git
  use { 'tpope/vim-fugitive' }
  use { 'junegunn/gv.vim'}
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }

  -- Status line
  use {
    'glepnir/galaxyline.nvim',
      branch = 'main',
  }

  use { 'kyazdani42/nvim-tree.lua' }

  -- Highlight
  use { 'nvim-treesitter/nvim-treesitter' }

  -- Icons
  use { 'ryanoasis/vim-devicons' }
  use { 'ryanoasis/nvim-web-devicons' }

  -- Tab like buffer
  use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}

  -- Ediing Helper
  use { 'windwp/nvim-autopairs' }
  use { 'norcalli/nvim-colorizer.lua' }
  require('colorizer').setup()
  use { 'sbdchd/neoformat' }
  use { 'alvan/vim-closetag' }
  use { 'ntpeters/vim-better-whitespace' }
  use { 'tomtom/tcomment_vim' }
  use { 'tommcdo/vim-lion' }

  -- Navigation
  use { 'easymotion/vim-easymotion' }
  use { 'unblevable/quick-scope'}

  -- Other helps
  use { 'junegunn/vim-peekaboo' }
  use { 'mhinz/vim-startify' }

  use { 'machakann/vim-sandwich' }
  use { 'machakann/vim-highlightedyank' }
  use { 'kana/vim-textobj-user' }
  use { 'kana/vim-textobj-entire' }
  use { 'beloglazov/vim-textobj-quotes' }
  use {'mbbill/undotree'}


  -- Debug
  use { 'tweekmonster/startuptime.vim' }

end)
