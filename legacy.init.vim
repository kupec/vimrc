autocmd VimEnter * colorscheme PaperColor

" vimrc

function! s:vimrc_commit_and_push()
    Git add --all
    autocmd BufDelete .git/COMMIT_EDITMSG ++once execute "Gpush | echom 'pushed!'"
    Gcommit
endfunction

nnoremap <silent> <leader>rcg :call <SID>vimrc_commit_and_push()<CR>

" navigation
runtime conf/qp_js_import.vim
runtime conf/qp_file_lines_view.vim
runtime conf/qp_js_file_lines_view.vim
runtime conf/qp_python_file_lines_view.vim

" fast macro

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

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
