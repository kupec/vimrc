vim.api.nvim_create_autocmd('VimEnter', {
    command = 'colorscheme PaperColor'
})

-- check file changes on focus
vim.api.nvim_create_autocmd({
    'FocusGained',
    'BufEnter',
    'CursorHold',
    'CursorHoldI',
}, {
    callback = function()
        local mode_regex = vim.regex('\v(c|r.?|!|t)')
        local mode = vim.fn.mode()
        if mode_regex:match_str(mode) and vim.fn.getcmdwintype() == '' then
            vim.cmd('checktime')
        end
    end,
})

-- notification after file change
vim.api.nvim_create_autocmd('FileChangedShellPost', {
    command = 'echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None'
})

-- terminal
vim.api.nvim_create_autocmd('TermOpen', {
    command = 'startinsert',
})
