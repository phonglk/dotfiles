set shell=bash

if has('nvim')
	source ~/.vim/nvim.vim
endif

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

source ~/.vim/plugins.vim
source ~/.vim/config.vim
source ~/.vim/mapping.vim
source ~/.vim/command.vim

set exrc
set secure
