set nocompatible
set expandtab
set tabstop=4
set shiftwidth=4
set number
set cursorline
set hlsearch
set t_Co=256
set autoread
set splitright
set splitbelow
syntax enable

if !has('nvim')
  set guioptions -=m 
  set guioptions -=T
endif

let g:netrw_browsex_viewer="setsid xdg-open"

let mapleader=","

call plug#begin('~/.vim/plugged')

" sudo
Plug 'lambdalisue/suda.vim'

" format
Plug 'editorconfig/editorconfig-vim'
Plug 'prettier/vim-prettier'
Plug 'frazrepo/vim-rainbow'
" format js
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'ianks/vim-tsx'
" format go
Plug 'fatih/vim-go'
" format python
Plug 'vim-python/python-syntax'

" movement
Plug 'easymotion/vim-easymotion'
" editing
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'arthurxavierx/vim-caser'
" autocomplete
Plug 'wellle/tmux-complete.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
" file manager
Plug 'scrooloose/nerdtree'
" markdown preview
" [install]: npm i -g livedown
" [help]: :Livedown*
Plug 'shime/vim-livedown'
" git plugin
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" linter
" [help]: :ALEToggle
Plug 'w0rp/ale'
" color scheme
Plug 'NLKNguyen/papercolor-theme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" highlight
Plug 'lfv89/vim-interestingwords'
" environment
Plug 'vim-scripts/tcd.vim'
" windows
Plug 'wesQ3/vim-windowswap'
" snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" terminal
Plug 'kassio/neoterm'

call plug#end()

let g:suda#prefix = ['suda://', 'sudo://']

let g:ackprg = 'ag --vimgrep -Q'
let $FZF_DEFAULT_COMMAND = 'ag --hidden -g ""'

let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['flake8'],
\}
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'python': ['autopep8', 'isort'],
\}
let g:ale_fix_on_save = 0

let g:airline_theme='papercolor'

let g:rainbow_active = 1

let g:python_highlight_all = 1

let g:prettier#exec_cmd_async = 1
autocmd FileType python nnoremap <buffer> <leader>p :ALEFix<CR>

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

set background=light
autocmd VimEnter * colorscheme PaperColor

" console
tnoremap <C-J> <C-\><C-N>

" motion
nmap <leader>m <Plug>(easymotion-overwin-f2)

" vimrc
nnoremap <leader>rcl :so $MYVIMRC<CR>
nnoremap <leader>rco :tabnew ~/.vim/vimrc<CR>
nnoremap <leader>rcg :w<CR>:Gwrite<CR>:Gcommit -v<CR>

" todo
command! TODO :tabnew ~/proj/TODO
nnoremap <leader>rcl :so $MYVIMRC<CR>
nnoremap <leader>rco :tabnew ~/.vim/vimrc<CR>
nnoremap <leader>rcg :w<CR>:Gwrite<CR>:Gcommit -v<CR>

" fzf
nnoremap <CR><CR> :FZF<CR>
nnoremap <CR><tab> :FZF -q <C-R><C-W><CR>
vnoremap <CR><tab> "wy:FZF -q <C-R>w<CR>
nnoremap <CR><space> :GFiles<CR>
nnoremap <space><CR> :Buffers<CR>
nnoremap <space><space> :Ack!<space>""<Left>
nnoremap <space><tab> :Ack! "<C-R><C-W>"<CR>
vnoremap <space><tab> "wy:Ack! "<C-R>w"<CR>
nnoremap <space><leader><space> :Ag<CR>
nnoremap <space><leader><tab> :Ag <C-R><C-W><CR>
vnoremap <space><leader><tab> "wy:Ag <C-R>w<CR>

" nerdtree
nnoremap <leader>nE :NERDTree<CR>
nnoremap <leader>ne :NERDTreeFocus<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
nnoremap <leader>nc :NERDTreeClose<CR>

" navigation

nnoremap <leader>rj<tab> vi'"wy:execute ':new ' . OpenFileByRelativePath('<C-R>w.js')<CR>
nnoremap <leader>rf<tab> vi'"wy:execute ':new ' . OpenFileByRelativePath('<C-R>w')<CR>

" tests

nnoremap <leader>to :Tnew<CR>
nnoremap <leader>tr :Tclear<CR>
nnoremap <leader>tt :Ttoggle<CR>

" ALE
nnoremap ]l :ALENext<CR>
nnoremap [l :ALEPrevious<CR>
nnoremap <leader>ll :ALEHover<CR>
nnoremap <leader>ld :ALEDetail<CR><C-W>J

" coc
inoremap <silent><expr> <c-space> coc#refresh()

" emmet

nmap <leader>cts va"<esc>`<BcwclassName<esc>f"lcs"{lsstyles.<esc>WX

" fast home/end
inoremap II <esc>I
inoremap AA <esc>A
nnoremap 0 ^

" paste current filename
inoremap <C-\><C-f><C-n> <C-R>=expand("%:t:r")<CR>

" find on mdn
nnoremap <silent> <leader>dm :execute "!" g:netrw_browsex_viewer "'https://developer.mozilla.org/en-US/search?q=<C-R><C-W>'"<CR>

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

" fast macro

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Project tabs

command! -nargs=1 -complete=file OpenProject :call OpenProject(<q-args>)
function! OpenProject(path)
   let l:pwd = getcwd()
   execute "Tcd " . l:pwd
   execute "tabnew " . a:path
   execute "Tcd " . a:path
endfunction

nnoremap <leader>op :OpenProject ~/proj/
nnoremap <leader>oo :cd ~/proj/


" Triger `autoread` when files changes on disk
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
  \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

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

command! -nargs=* ColorOpacify call ColorOpacify(<f-args>)

function! ColorOpacify(hex_color, opacity) 
    execute "read !node -e '" .
        \ "const hex = process.argv[1];" .
        \ "const opacity = parseInt(process.argv[2]) / 100;" .
        \ "const parse = (i) => parseInt(hex.slice(i, i+2), 16);" .
        \ "const colors = [parse(0), parse(2), parse(4)];" .
        \ "const mappedColors = colors.map(c => Math.round(c * opacity));" .
        \ 'const result = mappedColors.map(c => c.toString(16)).join("");' .
        \ "console.log(result);"
        \ "'"
        \ " " . a:hex_color . " " . a:opacity
endfunction

""" compile/run/test functions

command! StartNear :call StartNear()
command! StopNear :call StopNear()

function! StartNear()
    execute "belowright :vnew"
    let g:near_term = termopen($SHELL)
    execute "normal! \<C-W>t"
    stopinsert
endfunction

function! StopNear()
    call chanclose(g:near_term)
endfunction

function! RunNear(prog)
    call chansend(g:near_term, "\f" . a:prog . "\n")
endfunction

nnoremap <leader>c :call RunNear(b:compile_prog)<CR>
nnoremap <leader>t :call RunNear(b:test_prog)<CR>
