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
	" }}}
	" }}}
	" {{{ LSP
        Plug 'neoclide/coc.nvim', {'do': 'yarn install'}
        " Plug 'prabirshrestha/asyncomplete.vim'
        " Plug 'prabirshrestha/async.vim'
        " Plug 'prabirshrestha/vim-lsp'
        " Plug 'prabirshrestha/asyncomplete-lsp.vim'
        " Plug 'dense-analysis/ale'
        " }}}
    " }}}

    " {{{ Languages
        " {{{ Syntax
        Plug 'pangloss/vim-javascript'
        Plug 'leafgarland/typescript-vim'
        Plug 'MaxMEllon/vim-jsx-pretty', {'for': ['typescript', 'javascript', 'typescriptreact', 'javascriptreact']}
        " }}}
        " {{{ Javascript/React.JS
        Plug 'jparise/vim-graphql'
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
call plug#end()

" vim: foldmethod=marker:foldlevel=1