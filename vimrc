set tabstop=2
set shiftwidth=2
set number

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
" format
Plugin 'editorconfig/editorconfig-vim'
" fuzy search
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
" file manager
Plugin 'scrooloose/nerdtree'
Plugin 'leafgarland/typescript-vim'
" markdown preview
" [install]: npm i -g livedown
" [help]: :Livedown*
Plugin 'shime/vim-livedown'
" git plugin
Plugin 'tpope/vim-fugitive'

call vundle#end()

filetype plugin indent on


function! Ide()
	execute 'NERDTree'
endfunction
" autocmd VimEnter * NERDTree
