local fn = vim.fn
local execute = vim.api.nvim_command

-- Auto install packer.nvim if not exists
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

vim.cmd 'packadd packer.nvim'
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

return require('packer').startup(function()

  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}

  -- Color scheme
  use  'sainnhe/gruvbox-material' 
  use  'Th3Whit3Wolf/one-nvim' 
  use  'patstockwell/vim-monokai-tasty' 
  use  'Iron-E/nvim-highlite'
  use  'sainnhe/sonokai'
  use  'crusoexia/vim-monokai'
  use 'morhetz/gruvbox'
  use 'tomasr/molokai'

  -- Fuzzy finder
  use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }
  -- use {
  --   "nvim-telescope/telescope-frecency.nvim",
  --   config = function()
  --     require"telescope".load_extension("frecency")
  --   end
  -- }

  -- LSP
  use { 'neovim/nvim-lspconfig' }
  -- show icon for suggestion
  use { 'onsails/lspkind-nvim' }
  -- use { 'anott03/nvim-lspinstall' }
  -- use {'RishabhRD/popfix' }
  -- use {'RishabhRD/nvim-lsputils' }
  -- similar to nvim-lsputils: replace default nvim lsp ui
  use 'glepnir/lspsaga.nvim'

  -- Completion
  -- use { 'nvim-lua/completion-nvim' }
  use { 'hrsh7th/nvim-compe' }
  use { 'hrsh7th/vim-vsnip' }
  use { 'hrsh7th/vim-vsnip-integ' }
  use 'honza/vim-snippets'

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
  use 'f-person/git-blame.nvim'

  -- Status line
  use {
    'glepnir/galaxyline.nvim',
      branch = 'main',
  }

  -- tree file browser
  use { 'kyazdani42/nvim-tree.lua' }

  -- Highlight
  use { 'nvim-treesitter/nvim-treesitter' }
  use 'nvim-treesitter/nvim-treesitter-refactor'
  use 'p00f/nvim-ts-rainbow'

  -- Icons
  use { 'kyazdani42/nvim-web-devicons' }
  use { 'ryanoasis/vim-devicons' }

  -- Tab like buffer
  use 'romgrk/barbar.nvim'
  -- use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}

  -- Editing Helper
  use { 'windwp/nvim-autopairs' }
  use { 'norcalli/nvim-colorizer.lua' }
  require('colorizer').setup()
  use { 'sbdchd/neoformat' }
  use { 'alvan/vim-closetag' }
  use { 'ntpeters/vim-better-whitespace' }
  use { 'tomtom/tcomment_vim' }
  use { 'tommcdo/vim-lion' }

  -- Improve qf window
  -- use 'kevinhwang91/nvim-bqf'

  -- Navigation
  use { 'easymotion/vim-easymotion' }
  use { 'unblevable/quick-scope'}
  -- smooth scrolling
  use 'psliwka/vim-smoothie'

  -- Other helps
  use { 'junegunn/vim-peekaboo' }
  use { 'mhinz/vim-startify' }

  use { 'machakann/vim-sandwich' }
  use { 'machakann/vim-highlightedyank' }
  use { 'kana/vim-textobj-user' }
  use { 'kana/vim-textobj-entire' }
  use { 'beloglazov/vim-textobj-quotes' }
  use {'mbbill/undotree'}

  -- repl
  use 'metakirby5/codi.vim'


  -- Debug
  use { 'tweekmonster/startuptime.vim' }

end)
