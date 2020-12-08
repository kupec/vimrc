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

let g:ackprg = 'rg --vimgrep --fixed-strings'

function! s:is_ubuntu()
    return trim(system('which apt >/dev/null && echo 1')) == '1'
endfunction

let fzf_command_args = '--type file --hidden --exclude .git --exclude node_modules'
if s:is_ubuntu()
    let $FZF_DEFAULT_COMMAND = 'fdfind ' . fzf_command_args
else
    let $FZF_DEFAULT_COMMAND = 'fd ' . fzf_command_args
endif

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

let g:windowswap_map_keys = 0

let g:airline_theme='papercolor'

let g:rainbow_active = 1

let g:python_highlight_all = 1

let g:prettier#exec_cmd_path = 0
if prettier#PrettierCli('--version') < '2.0'
  let g:prettier#config#arrow_parens = 'avoid'
endif
let g:prettier#exec_cmd_async = 1
let g:prettier#quickfix_auto_focus = 0
autocmd FileType python nnoremap <buffer> <leader>p :ALEFix<CR>

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

set background=light
autocmd VimEnter * colorscheme PaperColor

command! -nargs=1 OpenProjectInNewTab :call OpenProjectInNewTab(<q-args>)
function! OpenProjectInNewTab(path)
   let l:pwd = getcwd()
   execute "Tcd " . l:pwd
   execute "tabnew " . a:path
   execute "Tcd " . a:path
endfunction

" search
nnoremap <leader>/ :noh<CR>

" console
tnoremap <C-J> <C-\><C-N>

" motion 
nmap <leader>m <Plug>(easymotion-overwin-f2)

" windows
nnoremap <silent> <leader>ww :call WindowSwap#EasyWindowSwap()<CR>

" vimrc
nnoremap <leader>rcl :so $MYVIMRC<CR>
nnoremap <leader>rco :OpenProjectInNewTab ~/.vim<CR>:e ~/.vim/vimrc<CR>
nnoremap <leader>rcg :w<CR>:Gwrite<CR>:Gcommit -v<CR>

" todo
command! TODO :tabnew ~/proj/TODO

" fzf
nnoremap <CR><CR> :FZF<CR>
nnoremap <CR><tab> :FZF -q <C-R><C-W><CR>
vnoremap <CR><tab> "wy:FZF -q <C-R>w<CR>
nnoremap <CR><space> :GFiles<CR>
nnoremap <space><CR> :Buffers<CR>
nnoremap <space><space> :Ack!<space>""<Left>
nnoremap <space><tab> :Ack! "<C-R><C-W>"<CR>
vnoremap <space><tab> "wy:Ack! "<C-R>w"<CR>
nnoremap <space><leader><space> :Rg<CR>
nnoremap <space><leader><tab> :Rg <C-R><C-W><CR>
vnoremap <space><leader><tab> "wy:Rg <C-R>w<CR>
nnoremap <space>/ :Lines<CR>

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

" nerdtree
nnoremap <leader>nE :NERDTree<CR>
nnoremap <leader>ne :NERDTreeFocus<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
nnoremap <leader>nc :NERDTreeClose<CR>

" navigation
runtime conf/qp_js_import.vim

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

function! SelectProjectAndRun(command)
    call fzf#run({'source': 'find ~/proj -mindepth 1 -maxdepth 1', 'sink': a:command})
endfunction

nnoremap <leader>op :call SelectProjectAndRun("OpenProjectInNewTab")<CR>
nnoremap <leader>oo :call SelectProjectAndRun("Tcd")<CR>


" Triger `autoread` when files changes on disk
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
  \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" terminal
autocmd TermOpen * startinsert

command! TerminalBufferDirectory :call TerminalBufferDirectory()
function! TerminalBufferDirectory()
  let l:dir = expand('%:h')
  vnew
  call termopen('cd '.l:dir.'; $SHELL -i')
endfunction

"""" util functions
runtime conf/qp_util.vim

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

nnoremap <expr> <leader>c RunNear(b:compile_prog)
nnoremap <expr> <leader>t RunNear(b:test_prog)
