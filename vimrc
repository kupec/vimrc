set tabstop=2
set shiftwidth=2
set number
set hlsearch

let mapleader=","

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
" format
Plugin 'editorconfig/editorconfig-vim'
Plugin 'prettier/vim-prettier'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
" editing
Plugin 'mattn/emmet-vim'
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
" linter
" [help]: :ALEToggle
Plugin 'w0rp/ale'


call vundle#end()

filetype plugin indent on




let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}


" vimrc
nnoremap <leader>rcl :so $MYVIMRC<CR>
nnoremap <leader>rco <C-W>v:e ~/.vim/vimrc<CR>
nnoremap <leader>rcg :w<CR>:Gwrite<CR>:Gcommit -v<CR>


inoremap II <esc>I
inoremap AA <esc>A

" wrap words
nnoremap <leader>w' bi'<esc>ea'<esc>
nnoremap <leader>w" bi"<esc>ea"<esc>
nnoremap <leader>w{ bi{<esc>ea}<esc>

" add empty lines
nnoremap <F2> m`O<esc>``
nnoremap <F3> m`o<esc>``
nnoremap <F4> m`O<esc>``m`o<esc>``

inoremap <F2> <esc>m`O<esc>``a
inoremap <F3> <esc>m`o<esc>``a
inoremap <F4> <esc>m`o<esc>``m`O<esc>``a

" remove near lines
nnoremap <C-F2> m`kdd``
nnoremap <C-F3> m`jdd``
nnoremap <C-F4> m`kdd``m`jdd``

inoremap <C-F2> <esc>m`kdd``a
inoremap <C-F3> <esc>m`jdd``a
inoremap <C-F4> <esc>m`kdd``m`jdd``a

" abbrev for funcs and propTypes
abbrev ASF async function() {}
abbrev FU function() {}
abbrev CP const {} = props
abbrev CTP const {} = this.props
abbrev PTF PropTypes.func.isRequired,
abbrev PTB PropTypes.bool,
abbrev PTN PropTypes.number,
abbrev PTS PropTypes.string,
abbrev PTR isRequired,


function! Ide()
	execute 'NERDTree'
endfunction
" autocmd VimEnter * NERDTree
