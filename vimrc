set expandtab
set tabstop=4
set shiftwidth=4
set number
set cursorline
set hlsearch
set t_Co=256
set autoread
syntax enable

if !has('nvim')
  set guioptions -=m 
  set guioptions -=T
endif

let g:netrw_browsex_viewer="setsid xdg-open"

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
Plugin 'fatih/vim-go'
" movement
Plugin 'easymotion/vim-easymotion'
" editing
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-abolish'
" search
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'mileszs/ack.vim'
" denite
Plugin 'Shougo/denite.nvim'
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'
" file manager
Plugin 'scrooloose/nerdtree'
Plugin 'leafgarland/typescript-vim'
" markdown preview
" [install]: npm i -g livedown
" [help]: :Livedown*
Plugin 'shime/vim-livedown'
" git plugin
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
" linter
" [help]: :ALEToggle
Plugin 'w0rp/ale'
" color scheme
Plugin 'altercation/vim-colors-solarized'
Plugin 'jonathanfilip/vim-lucius'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" environment
Plugin 'vim-scripts/tcd.vim'
" windows
Plugin 'wesQ3/vim-windowswap'
" snippets
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

call vundle#end()

filetype plugin indent on


let g:ackprg = 'ag --vimgrep -Q'

let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}

let g:ale_linters = {
\   'javascript': ['eslint'],
\}
let g:airline_theme='papercolor'

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

colorscheme PaperColor
set background=light

" motion
nmap <leader>m <Plug>(easymotion-overwin-f2)


" vimrc
nnoremap <leader>rcl :so $MYVIMRC<CR>
nnoremap <leader>rco :tabnew ~/.vim/vimrc<CR>
nnoremap <leader>rcg :w<CR>:Gwrite<CR>:Gcommit -v<CR>

" fzf
nnoremap <CR><CR> :FZF<CR>
nnoremap <CR><tab> :FZF -q <C-R><C-W><CR>
vnoremap <CR><tab> "wy:FZF -q <C-R>w<CR>
nnoremap <CR><space> :GFiles<CR>
nnoremap <space><CR> :Buffers<CR>
nnoremap <space><space> :Ack!<space>
nnoremap <space><tab> :Ack! <C-R><C-W><CR>
vnoremap <space><tab> "wy:Ack! '<C-R>w'<CR>

" nerdtree
nnoremap <leader>nE :NERDTree<CR>
nnoremap <leader>ne :NERDTreeFocus<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" navigation

nnoremap <leader>rj<tab> vi'"wy:execute ':new ' . OpenFileByRelativePath('<C-R>w.js')<CR>
nnoremap <leader>rf<tab> vi'"wy:execute ':new ' . OpenFileByRelativePath('<C-R>w')<CR>

" ALE
nnoremap ]l :ALENext<CR>
nnoremap [l :ALEPrevious<CR>

" emmet

nmap <leader>cts va"<esc>`<BcwclassName<esc>f"lcs"{lsstyles.<esc>WX

" fast home/end
inoremap II <esc>I
inoremap AA <esc>A
nnoremap 0 ^

" paste current filename
inoremap <C-\><C-f><C-n> <C-R>=expand("%:t:r")<CR>

" wrap words
nnoremap <leader>w' bi'<esc>ea'<esc>
nnoremap <leader>w" bi"<esc>ea"<esc>
nnoremap <leader>w{ bi{<esc>ea}<esc>

" add empty lines
nnoremap <F2> m`o<esc>``
nnoremap <F3> m`O<esc>``
nnoremap <F4> m`O<esc>``m`o<esc>``

inoremap <F2> <esc>m`o<esc>``a
inoremap <F3> <esc>m`O<esc>``a
inoremap <F4> <esc>m`o<esc>``m`O<esc>``a

" remove near lines
nnoremap <C-F2> m`jdd``
nnoremap <C-F3> m`kdd``
nnoremap <C-F4> m`kdd``m`jdd``

inoremap <C-F2> <esc>m`jdd``a
inoremap <C-F3> <esc>m`kdd``a
inoremap <C-F4> <esc>m`kdd``m`jdd``a

" console.log
inoremap <C-\>cl console.log('AAA', );<esc>T,a

" terminal
if has('nvim')
    autocmd TermOpen * startinsert
endif

command! TerminalBufferDirectory :call TerminalBufferDirectory()
function! TerminalBufferDirectory()
  let l:dir = expand('%:h')
  vnew
  call termopen('cd '.l:dir.'; $SHELL -i')
endfunction

" abbrev git
abbrev GPC Partial commit

" abbrev for funcs and propTypes
abbrev ASF async function() {}
abbrev FU function() {}
abbrev CP const {} = props
abbrev CTP const {} = this.props
abbrev PTF PropTypes.func.isRequired,
abbrev PTO PropTypes.object.isRequired,
abbrev PTo PropTypes.object,
abbrev PTB PropTypes.bool,
abbrev PTN PropTypes.number,
abbrev PTS PropTypes.string,
abbrev PTA PropTypes.array.isRequired,
abbrev PTa PropTypes.array,
abbrev PTR isRequired,

" abbrev for node
abbrev ME module.exports =

" abbrev for css
abbrev BG background: url(./assets/) no-repeat center / contain;

"""" util functions

function! Random(min, max)
	let l:a = system('echo -n $RANDOM')
	return l:a % (1 + a:max - a:min) + a:min
endfunction

function! OpenFileByRelativePath(relPath)
	let l:bufferCwd = expand('%:p:h')
	let l:path = system('node -e "console.log(path.resolve(\"' .  l:bufferCwd .  '\", \"' . a:relPath . '\"))"')
	return l:path
endfunction

command! -range JsonToKeys <line1>,<line2>!python3 -c 'import json;import sys;s = "".join(x for x in sys.stdin);a = json.loads(s);print("\n".join(x for x in a.keys()))'

""" css functions

command! CssAbsolute :normal i position: absolute;<CR>left: 0;<CR>top: 0;<CR>width: 100%;<CR>height: 100%;<CR>
command! CssFlex :normal i display: flex;<CR>flex-flow: column;<CR>justify-content: center;<CR>align-items: center;

""" dirty

function! Ide()
	execute 'NERDTree'
endfunction
" autocmd VimEnter * NERDTree
