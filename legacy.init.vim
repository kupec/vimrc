autocmd VimEnter * colorscheme PaperColor

function! s:open_project(path)
   execute "tcd " . a:path
   new
   setlocal nonumber

   for i in range(winheight('.') / 2 - 1)
       call append(0, '')
   endfor

   call append(line('$'), ["Project: " . a:path, "Please open a file"])
   execute "$-1,$center" winwidth('.')
   set nomodified

   execute "normal \<C-W>o"
endfunction

function! s:open_project_in_new_tab(path)
   let pwd = getcwd()
   execute "tcd " . pwd

   execute "tabnew"

   call s:open_project(a:path)
endfunction


" vimrc

function! s:vimrc_commit_and_push()
    Git add --all
    autocmd BufDelete .git/COMMIT_EDITMSG ++once execute "Gpush | echom 'pushed!'"
    Gcommit
endfunction

nnoremap <silent> <leader>rcl :so $MYVIMRC<CR>
nnoremap <silent> <leader>rco :call <SID>open_project_in_new_tab(stdpath("config"))<CR>:e $MYVIMRC<CR>
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

" Project tabs

function! s:select_project_and_run(sink)
    call fzf#run({
                \'source': g:fd_prog . ' . ~/proj --type d --max-depth 1',
                \'sink': a:sink,
                \'options': ['--preview', 'cat {}/README.md'],
                \})
endfunction

nnoremap <leader>op :call <SID>select_project_and_run(function("<SID>open_project_in_new_tab"))<CR>
nnoremap <leader>oo :call <SID>select_project_and_run(function("<SID>open_project"))<CR>


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
