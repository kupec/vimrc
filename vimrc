set tabstop=2
set shiftwidth=2
set number

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'leafgarland/typescript-vim'
" markdown preview
" [install]: npm i -g livedown
" [help]: :Livedown*
Plugin 'shime/vim-livedown'
Plugin 'tpope/vim-fugitive'

call vundle#end()

filetype plugin indent on


function! Ide()
	execute 'NERDTree'
endfunction
" autocmd VimEnter * NERDTree
