function! s:find_oneline_test_lines()
    return FindLinesByRegexp('\v^\s*(describe|test|it)\(')
endfunction

function! s:find_multiline_test_each_lines()
    let old_pos = getcurpos()
    call cursor(1, 1)

    let items = []
    let test_each_pattern = '^\s*\%(describe\|test\|it\).each[`(]'

    while 1
        let test_line_nr = search(test_each_pattern, 'W')
        if test_line_nr == 0
            break
        endif

        let end_test_line_nr = searchpair(test_each_pattern, '', '\v^\s*`', 'W')

        let test_line = getline(test_line_nr)
        let end_test_line = getline(end_test_line_nr)

        call insert(items, [test_line_nr, test_line . trim(end_test_line)], 0)
    endwhile

    call setpos('.', old_pos)

    return items
endfunction

function! s:get_test_lines()
    return s:find_oneline_test_lines() + s:find_multiline_test_each_lines()
endfunction

function s:symbols_regexp()
    return '\v(^async|^export|^function|^const|^let|^var|^class|^type|^interface)'
endfunction

autocmd FileType javascript,javascript.jsx,typescript,typescript.tsx nnoremap <space>t :call QpShowFileLines(<SID>get_test_lines())<cr>
autocmd FileType javascript,javascript.jsx,typescript,typescript.tsx nnoremap <space>s :call QpShowFileLines(<SID>symbols_regexp())<cr>
