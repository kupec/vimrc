function! s:find_test_lines()
    let old_pos = getcurpos()
    call cursor(1, 1)

    let items = []

    while 1
        let test_line_nr = search('\vdef test_', 'W')
        if test_line_nr == 0
            break
        endif

        let test_line = getline(test_line_nr)
        call insert(items, [test_line_nr, test_line], 0)
    endwhile

    call setpos('.', old_pos)

    return items
endfunction

function! s:pad_left(str, width, ...)
    let pad_char = get(a:, 3, ' ')

    if len(a:str) >= a:width
        return a:str
    endif

    return repeat(pad_char, a:width - len(a:str)) . a:str
endfunction

function! s:prepare_test_lines()
    let test_list = s:find_test_lines()
    call sort(test_list, {i1, i2 -> i2[0] >= i1[0] ? 1 : -1})
    call map(test_list, {_, val -> s:pad_left(string(val[0]), 4) . ":" . val[1]})
    return test_list
endfunction

function! s:do_show_test_lines(test_line)
    let [test_line_nr; _] = split(a:test_line, ':')
    let curpos = getpos('.')
    let curpos[1] = str2nr(test_line_nr)
    call setpos('.', curpos)
    normal zz
endfunction

function! s:show_test_lines()
    let cur_file = expand('%')

    call fzf#run({
                \'source': s:prepare_test_lines(),
                \'sink': function('s:do_show_test_lines'),
                \'options': ['--preview', 'tail -n +$(echo {} | sed ''s/^\s*\([^:]\+\):.*$/\1/'') ' . cur_file],
                \})
endfunction

autocmd FileType python nnoremap <space>t :call <SID>show_test_lines()<CR>
