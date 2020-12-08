function! s:get_delimited_word_under_cursor(delimiters)
    let line = getline(".")
    let col = col(".")

    let left = col - 1
    while left >= 0
        let found_delimiter = 0
        for d in a:delimiters
            if line[left] == d
                let found_delimiter = 1
                break
            endif
        endfor

        if found_delimiter
            break
        endif

        let left -= 1
    endwhile
    let left += 1

    let right = col - 1
    while right < len(line)
        let found_delimiter = 0
        for d in a:delimiters
            if line[right] == d
                let found_delimiter = 1
                break
            endif
        endfor

        if found_delimiter
            break
        endif

        let right += 1
    endwhile
    let right -= 1

    return line[left:right]
endfunction

function! s:create_file_under_cursor(file_ext)
    let file_path = s:get_delimited_word_under_cursor(["'", '"', " "])
    let file_ext = a:file_ext != "" ? a:file_ext : input("Type file extension: ")

    if len(file_ext) > 0
        let file_path = file_path . "." . file_ext
    endif

    let cur_path = expand("%:p:h")
    let file_path = fnamemodify(cur_path . "/" . file_path, ":.")
    let dir_path = fnamemodify(file_path, ":h")

    call system("mkdir -p " . dir_path)
    execute "new " . file_path 
    write
endfunction

function! s:get_import_js_file_path(file_path)
    let cur_path = expand("%:p:h")
    let file_path = fnamemodify(a:file_path, ":p")
    let rel_path = trim(system("realpath -m --relative-to " . cur_path . " " . file_path))

    echom "rel = " . rel_path

    if rel_path[0] != '.'
        let rel_path = "./" . rel_path
    endif

    return substitute(rel_path, '\(\.js\|\.jsx\|\.ts\|\.tsx\)$', '', '')
endfunction

function! s:do_import_js_file(file_path)
    let rel_path = s:get_import_js_file_path(a:file_path)
    let base_file_name = fnamemodify(rel_path, ":p:t:r")

    let import_line = "import " . base_file_name . " from '" . rel_path . "';"
    call append(line("."), import_line)
endfunction

function! s:import_js_file()
    call fzf#run({'sink': function('s:do_import_js_file'), 'options': '--multi'})
endfunction

function! s:do_mock_js_file(file_path)
    let rel_path = s:get_import_js_file_path(a:file_path)

    let import_line = "jest.mock('" . rel_path . "');"
    call append(line("."), import_line)
endfunction

function! s:mock_js_file()
    call fzf#run({'sink': function('s:do_mock_js_file'), 'options': '--multi'})
endfunction

function! s:find_js_import_current_file()
    let file_name = expand('%:t:r')
    let import_pattern = shellescape('import.*' . file_name . "'")
    let file_pattern = shellescape('\b' . file_name . '\b')

    call fzf#run(fzf#wrap({ 
                \'source': "rg -l " . import_pattern,
                \'options': ['--preview', 'rg -C 5 --color always ' . file_pattern . ' {}' ],
                \}))
endfunction

nnoremap <silent> <leader>cf :call <SID>create_file_under_cursor("")<CR>
nnoremap <silent> <leader>cjf :call <SID>create_file_under_cursor("js")<CR>
nnoremap <silent> <leader>ijf :call <SID>import_js_file()<CR>
nnoremap <silent> <leader>imj :call <SID>mock_js_file()<CR>

nnoremap <silent> <leader>fif :call <SID>find_js_import_current_file()<CR>