function! FindLinesByRegexp(regexp)
    let old_pos = getcurpos()
    call cursor(1, 1)

    let items = []

    while 1
        let line_nr = search(a:regexp, 'W')
        if line_nr == 0
            break
        endif

        let line = getline(line_nr)
        call insert(items, [line_nr, line], 0)
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

function! s:prepare_lines(regexp_or_list)
    if type(a:regexp_or_list) == 1
        let regexp = a:regexp_or_list
        let lines = FindLinesByRegexp(regexp)
    else
        let lines = a:regexp_or_list
    endif

    call sort(lines, {i1, i2 -> i2[0] >= i1[0] ? 1 : -1})
    call map(lines, {_, val -> s:pad_left(string(val[0]), 4) . ":" . val[1]})
    return lines
endfunction

function! s:go_to_line(line)
    let [line_nr; _] = split(a:line, ':')
    let curpos = getpos('.')
    let curpos[1] = str2nr(line_nr)
    call setpos('.', curpos)
    normal zz
endfunction

function! QpShowFileLines(regexp_or_list)
    let cur_file = expand('%')

    call fzf#run({
                \'source': s:prepare_lines(a:regexp_or_list),
                \'sink': function('s:go_to_line'),
                \'options': ['--preview', 'tail -n +$(echo {} | sed ''s/^\s*\([^:]\+\):.*$/\1/'') ' . cur_file],
                \})
endfunction

function! QpInputShowFileLines()
    let regexp = "\v" . input("Type regexp: ")
    call QpShowFileLines(regexp)
endfunction

command! ShowFileLines call QpInputShowFileLines()
