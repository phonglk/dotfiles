-- vim: set foldmethod=marker:
local fn = vim.fn
local execute = vim.api.nvim_command

-- {{{ Auto install packer.nvim if not exists
local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
                install_path)
end

vim.cmd 'packadd packer.nvim'
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua
-- }}}

return require('packer').startup(function()

    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim', opt = true}

    -- {{{ Color scheme
    use 'Th3Whit3Wolf/one-nvim'
    use 'patstockwell/vim-monokai-tasty'
    use 'Iron-E/nvim-highlite'
    use 'sainnhe/sonokai'
    use 'tanvirtin/monokai.nvim'
    use 'yonlu/omni.vim'
    use 'ChristianChiarulli/nvcode-color-schemes.vim'
    -- }}}

    -- {{{ Fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
        config = function() require('config.telescope-nvim') end
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
    -- use {
    --   "nvim-telescope/telescope-frecency.nvim",
    --   config = function()
    --     require"telescope".load_extension("frecency")
    --   end
    -- }
    -- }}}

    -- {{{ LSP
    use {'neovim/nvim-lspconfig'}
    -- show icon for suggestion
    use {'onsails/lspkind-nvim'}
    -- use { 'anott03/nvim-lspinstall' }
    use {'RishabhRD/popfix'}
    use {'RishabhRD/nvim-lsputils'}
    use 'kabouzeid/nvim-lspinstall'
    -- similar to nvim-lsputils: replace default nvim lsp ui
    use 'glepnir/lspsaga.nvim'
    use 'nvim-lua/lsp-status.nvim'
    use 'liuchengxu/vista.vim'
    require('config.vista-vim')
    -- }}}

    -- {{{ Completion
    -- use {'nvim-lua/completion-nvim'}
    use {'hrsh7th/nvim-compe'}
    -- use 'rafamadriz/friendly-snippets'
    use {'hrsh7th/vim-vsnip'}
    use {'hrsh7th/vim-vsnip-integ'}
    -- use 'SirVer/ultisnips'
    require('config.nvim-compe')
    -- use 'honza/vim-snippets'
    -- This keep consuming CPU
    -- use {'tzachar/compe-tabnine'}
    -- }}}

    -- {{{ Language helper
    require('config.vim-polyglot')
    use {'sheerun/vim-polyglot', cmd = 'PolyglotEnable'}
    use 'AndrewRadev/tagalong.vim'
    -- Lua developmen
    -- use {'tjdevries/nlua.nvim'}
    -- }}}

    -- Vim dispatch
    use {'tpope/vim-dispatch'}

    -- {{{ Git
    use {'tpope/vim-fugitive'}
    use {'junegunn/gv.vim'}
    -- use {
    --     'lewis6991/gitsigns.nvim',
    --     requires = {'nvim-lua/plenary.nvim'},
    --     config = function() require('gitsigns').setup() end
    -- }
    use {
        'f-person/git-blame.nvim',
        config = function() require('config.git-blame-nvim') end
    }
    -- }}}

    -- {{{ Status line
    use {'glepnir/galaxyline.nvim', branch = 'main'}
    require('config.galaxyline')
    -- }}}

    -- tree file browser
    use {'kyazdani42/nvim-tree.lua'}
    require('config.nvim-tree')

    -- {{{ Highlight
    use {'nvim-treesitter/nvim-treesitter'}
    use 'nvim-treesitter/nvim-treesitter-refactor'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'nvim-treesitter/playground'
    require('config.nvim-treesitter')
    use 'p00f/nvim-ts-rainbow'
    -- temporary syntax until treesitter works for tsx
    -- use 'leafgarland/typescript-vim'
    -- use 'peitalin/vim-jsx-typescript'
    -- }}}

    -- {{{ Icons
    use {'ryanoasis/vim-devicons'}
    use {'kyazdani42/nvim-web-devicons'}
    -- }}}

    -- {{{ Tab like buffer
    use 'romgrk/barbar.nvim'
    require('config.barbar-nvim')
    -- use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}
    -- }}}

    -- {{{ Editing Helper
    use {'windwp/nvim-autopairs'}
    require('config.nvim-autopairs')
    use {'norcalli/nvim-colorizer.lua'}
    require('colorizer').setup()
    use {'sbdchd/neoformat'}
    use {'alvan/vim-closetag'}
    use {'ntpeters/vim-better-whitespace'}
    use {'tomtom/tcomment_vim'}
    use {'tommcdo/vim-lion'}
    -- }}}

    -- Improve qf window
    use 'kevinhwang91/nvim-bqf'
    -- fzf
    use {'junegunn/fzf', dir = '~/.fzf', run = './install --all'}
    -- use {'junegunn/fzf.vim'}

    -- {{{ Navigation
    -- use { 'easymotion/vim-easymotion' }
    use 'phaazon/hop.nvim'
    require('config.hop-nvim')
    use {'unblevable/quick-scope'}
    -- smooth scrolling
    use 'psliwka/vim-smoothie'
    -- }}}

    -- {{{ Other helps
    use {'junegunn/vim-peekaboo'}
    use {'mhinz/vim-startify'}
    use {'machakann/vim-sandwich'}
    use {'machakann/vim-highlightedyank'}
    use {'kana/vim-textobj-user'}
    use {'kana/vim-textobj-entire'}
    use {'beloglazov/vim-textobj-quotes'}
    use {'mbbill/undotree'}
    use 'tpope/vim-sleuth' -- auto indent detection
    use 'Konfekt/FastFold' -- must have when use foldmethod=syntax
    -- Mark utils
    use 'Yilin-Yang/vim-markbar'
    use {'liuchengxu/vim-which-key'}
    require('config.vim-which-key')
    -- repl
    use 'metakirby5/codi.vim'
    -- use 'andymass/vim-matchup'
    -- require('config.vim-matchup')
    -- }}}

    -- {{{ Debug
    use {'tweekmonster/startuptime.vim'}
    -- }}}

end)
