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
        call insert(items, [test_line_nr, test_line], 0)
    endwhile

    call setpos('.', old_pos)

    return items
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

function! s:pad_left(str, width, ...)
    let pad_char = get(a:, 3, ' ')

    if len(a:str) >= a:width
        return a:str
    endif

    return repeat(pad_char, a:width - len(a:str)) . a:str
endfunction

function! s:find_test_lines()
    let test_list = s:find_oneline_test_lines() + s:find_multiline_test_each_lines()
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
                \'source': s:find_test_lines(),
                \'sink': function('s:do_show_test_lines'),
                \'options': ['--preview', 'tail -n +$(echo {} | sed ''s/^\s*\([^:]\+\):.*$/\1/'') ' . cur_file],
                \})
endfunction

autocmd FileType javascript,javascript.jsx,typescript,typescript.tsx nnoremap <space>t :call <SID>show_test_lines()<CR>
