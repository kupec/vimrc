local show_file_lines = require'navigation.utils'.show_file_lines
local js = require 'navigation.js'

return function()
    vim.keymap.set('n', '<space>t', function()
        show_file_lines(js.get_test_lines())
    end)
    vim.keymap.set('n', '<space>s', function()
        show_file_lines(js.symbols_regexp())
    end)
end
