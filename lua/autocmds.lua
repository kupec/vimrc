local helpers = require 'autocmds_helpers'

vim.api.nvim_create_autocmd('VimEnter', {command = 'colorscheme PaperColor'})

-- check file changes on focus
vim.api.nvim_create_autocmd({'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI'}, {
    callback = function()
        local mode = vim.fn.mode()
        local is_mode_right = helpers.does_vim_mode_allow_file_changes(mode)
        if is_mode_right and vim.fn.getcmdwintype() == '' then
            vim.cmd('checktime')
        end
    end,
})

-- notification after file change
vim.api.nvim_create_autocmd('FileChangedShellPost', {
    command = 'echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None',
})

-- terminal
vim.api.nvim_create_autocmd('TermOpen', {command = 'startinsert'})
