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




inoremap II <esc>I
inoremap AA <esc>A

" wrap words
nnoremap <leader>w' bi'<esc>ea'<esc>
nnoremap <leader>w" bi"<esc>ea"<esc>

" add empty lines
noremap <F2> <esc>O<esc>j
noremap <F3> <esc>o<esc>k
noremap <F4> <esc>O<esc>j<esc>o<esc>k

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
