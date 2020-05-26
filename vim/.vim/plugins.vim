call plug#begin('~/.vim/plugged')


    " {{{ Assist
        " {{{ Autoclosing
        Plug 'ntpeters/vim-better-whitespace'
        Plug 'jiangmiao/auto-pairs'
        Plug 'alvan/vim-closetag'
        " }}}
        " {{{ Syntax
        Plug 'tomtom/tcomment_vim'
        Plug 'tommcdo/vim-lion'
        " }}}
        " {{{ Navigation
        Plug 'easymotion/vim-easymotion'
        Plug 'baspar/vim-cartographe'
        Plug 'scrooloose/nerdtree'
        Plug 'terryma/vim-multiple-cursors'
        Plug 'junegunn/vim-peekaboo'
        Plug 'mhinz/vim-startify'
        Plug 'unblevable/quick-scope'
	" }}}
	" }}}
	" {{{ LSP
        Plug 'neoclide/coc.nvim', {'do': 'yarn install'}
        " Plug 'prabirshrestha/asyncomplete.vim'
        " Plug 'prabirshrestha/async.vim'
        " Plug 'prabirshrestha/vim-lsp'
        " Plug 'prabirshrestha/asyncomplete-lsp.vim'
        " Plug 'dense-analysis/ale'
        Plug 'tmux-plugins/vim-tmux'
        " }}}
    " }}}

    " {{{ Languages
        " {{{ Syntax
        Plug 'pangloss/vim-javascript'
        Plug 'leafgarland/typescript-vim'
        Plug 'MaxMEllon/vim-jsx-pretty', {'for': ['typescript', 'javascript', 'typescriptreact', 'javascriptreact']}
        Plug 'jparise/vim-graphql'
        Plug 'sheerun/vim-polyglot'
        " }}}
    " {{{ Utils
        " {{{ Undo
        Plug 'mbbill/undotree'
        Plug 'tpope/vim-repeat'
        " }}}
        " {{{ File
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        Plug 'junegunn/fzf.vim'
        " }}}
        " {{{ Git
        Plug 'tpope/vim-fugitive'
        " Plug 'rbong/vim-flog'
        Plug 'junegunn/gv.vim'
        " }}}
        " {{{ Text Object
        Plug 'machakann/vim-sandwich'
        Plug 'machakann/vim-highlightedyank'
        Plug 'kana/vim-textobj-user'
        Plug 'kana/vim-textobj-entire'
        Plug 'beloglazov/vim-textobj-quotes'
        " }}}
        " {{{ Async
        Plug 'tpope/vim-dispatch'
        " }}}
    " }}}

    " {{{ UI
        " {{{ Colorschemes
        Plug 'AlessandroYorba/alduin'
        Plug 'morhetz/gruvbox'
        Plug 'arzg/vim-substrata'
        Plug 'crusoexia/vim-monokai'
        " }}}
        " {{{ Airline
        Plug 'itchyny/lightline.vim'
        " }}}
        " {{{ Goyo
        Plug 'junegunn/goyo.vim'
        Plug 'junegunn/limelight.vim'
        " }}}
    " }}}
    Plug 'Raimondi/delimitMate'

    Plug 'ryanoasis/vim-devicons'
    Plug 'vwxyutarooo/nerdtree-devicons-syntax'
call plug#end()

" vim: foldmethod=marker:foldlevel=1
