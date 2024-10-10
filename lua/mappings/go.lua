local show_file_lines = require'navigation.utils'.show_file_lines
local go = require 'navigation.go'

return function()
    vim.keymap.set('n', '<space>t', function()
        show_file_lines(go.tests_regexp())
    end)
    vim.keymap.set('n', '<space>s', function()
        show_file_lines(go.symbols_regexp())
    end)
end
