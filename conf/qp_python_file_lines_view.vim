autocmd FileType python nnoremap <space>t :call QpShowFileLines("\vdef test_")<cr>

function s:symbols_regexp()
    return '\v(<class>|<def>|^\w+\s*\=)'
endfunction

autocmd FileType python nnoremap <space>s :call QpShowFileLines(<SID>symbols_regexp())<cr>
