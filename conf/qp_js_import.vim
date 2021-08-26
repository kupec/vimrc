let s:script_dir = expand('<sfile>:h')

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

    call system("mkdir -p " . shellescape(dir_path))
    execute "vnew " . file_path 
    write
endfunction

function! s:get_import_js_file_path(file_path)
    if a:file_path =~ '^node_modules'
        let rel_path = substitute(a:file_path, '^node_modules/', '', '')
    else
        let cur_path = expand("%:p:h")
        let file_path = fnamemodify(a:file_path, ":p")
        let rel_path = trim(system("realpath -m --relative-to " . shellescape(cur_path) . " " . shellescape(file_path)))

        if rel_path[0] != '.'
            let rel_path = "./" . rel_path
        endif
    endif

    return substitute(rel_path, '\(\.js\|\.jsx\|\.ts\|\.tsx\)$', '', '')
endfunction

function! s:do_import_js_file(file_path)
    let rel_path = s:get_import_js_file_path(a:file_path)
    let base_file_name = fnamemodify(rel_path, ":p:t:r")

    let import_line = "import " . base_file_name . " from '" . rel_path . "';"
    call append(line("."), import_line)
endfunction

function! s:import_js_file(...)
    let fzf_run_dict = {'sink': function('s:do_import_js_file'), 'options': '--multi'}

    if a:0 == 1
        let search_root = a:1
        call extend(fzf_run_dict, {'source': g:fd_prog . ' -g ' . shellescape('*') . ' ' . search_root})
    endif

    call fzf#run(fzf_run_dict)
endfunction

function! s:do_import_js_lib(lib)
    let import_part = a:lib
    let import_path = a:lib

    echom "FILE=". s:script_dir . '/qp_js_import_lib'
    let config = readfile(s:script_dir . '/qp_js_import_lib')
    let special_imports = {}

    for line in config
        let tokens = split(line, '\v\s{2,}')
        if len(tokens) < 2
            continue
        endif

        let [config_lib, config_import_part] = tokens[0:1]

        if config_lib ==# a:lib
            let import_part = trim(config_import_part)
            if len(tokens) == 3
                let import_path = tokens[2]
            endif

            break
        endif
    endfor

    let import_line = "import " . import_part . " from '" . import_path . "';"
    call append(line("."), import_line)
endfunction

function! s:import_js_lib()
    let cur_dir = expand("%:h")
    let dir_count = len(split(cur_dir, '/')) + 1

    let i = 0
    while i < dir_count
        let package_json_file = cur_dir . '/package.json'
        if filereadable(package_json_file)
            let package_json = json_decode(readfile(package_json_file))
            break
        endif

        let [cur_dir] = systemlist('realpath -m ' . cur_dir . '/..')
        let i += 1
    endwhile

    if ! exists("package_json")
        echom "Cannot find package.json"
        return
    endif

    let lib_list = keys(get(package_json, 'dependencies', {})) + keys(get(package_json, 'devDependencies', {}))

    call fzf#run({
        \'source': lib_list,
        \'sink': function('s:do_import_js_lib'),
        \'options': '--multi'
        \})
endfunction

function! s:do_import_lodash_lib(lib)
    let import_line = "import " . a:lib . " from 'lodash/" . a:lib . "';"
    call append(line("."), import_line)
endfunction

function! s:import_lodash_lib()
    let files = split(glob('node_modules/lodash/*'), '\n')
    let lodash_items = filter(
                \map(files, {_,val -> fnamemodify(val, ':t:r')}),
                \'v:val =~# "^[a-z]"'
                \)

    call fzf#run({
        \'source': lodash_items,
        \'sink': function('s:do_import_lodash_lib'),
        \'options': '--multi'
        \})
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
    let import_pattern = shellescape('(import|require).*\b' . file_name . '\b')
    let file_pattern = shellescape('\b' . file_name . '\b')

    call fzf#run(fzf#wrap({ 
                \'source': "rg -l " . import_pattern,
                \'options': ['--preview', 'rg -C 5 --color always ' . file_pattern . ' {}' ],
                \}))
endfunction

function! s:find_js_target_of_current_test_file()
    let file_path = expand('%:r:r:r')
    let js_exts = ['js', 'jsx', 'ts', 'tsx']
    let js_exts_flags = join(map(js_exts, {_, ext -> '-e ' . ext}))

    call fzf#run(fzf#wrap({ 
                \'source': join([g:fd_prog, js_exts_flags, "-p -F -E '*.test.*'", shellescape(file_path)]),
                \}))
endfunction

nnoremap <silent> <leader>cf :call <SID>create_file_under_cursor("")<CR>
nnoremap <silent> <leader>cjf :call <SID>create_file_under_cursor("js")<CR>
nnoremap <silent> <leader>ijf :call <SID>import_js_file()<CR>
nnoremap <silent> <leader>iid :call <SID>import_js_file('node_modules/@infra/intdev')<CR>
nnoremap <silent> <leader>ijn :call <SID>import_js_lib()<CR>
nnoremap <silent> <leader>ijl :call <SID>import_lodash_lib()<CR>
nnoremap <silent> <leader>imj :call <SID>mock_js_file()<CR>

nnoremap <silent> <leader>fif :call <SID>find_js_import_current_file()<CR>
nnoremap <silent> <leader>ftt :call <SID>find_js_target_of_current_test_file()<CR>
