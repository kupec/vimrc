function! s:find_oneline_test_lines()
    let old_pos = getcurpos()
    call cursor(1, 1)

    let items = []

    while 1
        let test_line_nr = search('\v^\s*(describe|test|it)\(', 'W')
        if test_line_nr == 0
            break
        endif

        let test_line = getline(test_line_nr)
        call insert(items, test_line_nr . ":" . test_line, 0)
    endwhile

    call setpos('.', old_pos)

    return items
endfunction

function! s:find_test_lines()
    call fzf#run({
                \'source': s:find_oneline_test_lines(),
                \'sink': 'echo',
                \})
endfunction

nnoremap <space>t :call <SID>find_test_lines()<CR>
