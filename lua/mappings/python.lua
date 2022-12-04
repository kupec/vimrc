local show_file_lines = require'navigation.utils'.show_file_lines
local python = require'navigation.python'

return function()
    vim.keymap.set('n', '<space>t', function()
        show_file_lines(python.tests_regexp())
    end)
    vim.keymap.set('n', '<space>s', function()
        show_file_lines(python.symbols_regexp())
    end)
end
