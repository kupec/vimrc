local utils = require 'navigation.utils'

local E = {}

function E.find_oneline_test_lines()
    return utils.find_lines_by_regexp('\\v^\\s*(describe|test|it)\\(')
end

function E.find_multiline_test_each_lines()
    local old_pos = vim.fn.getcurpos()
    vim.fn.cursor(1, 1)

    local items = {}
    local test_each_pattern = '^\\s*\\%(describe\\|test\\|it\\).each[`(]'

    while true do
        local test_line_nr = vim.fn.search(test_each_pattern, 'W')
        if test_line_nr == 0 then
            break
        end

        local end_test_line_nr = vim.fn.searchpair(test_each_pattern, '', '\\v^\\s*(`|\\].*\\))', 'W')

        local test_line = vim.fn.getline(test_line_nr)
        local end_test_line = vim.fn.getline(end_test_line_nr)

        table.insert(items, {test_line_nr, test_line .. vim.fn.trim(end_test_line)})
    end

    vim.fn.setpos('.', old_pos)

    return items
end

function E.get_test_lines()
    local result = {}
    for _, line in ipairs(E.find_oneline_test_lines()) do
        table.insert(result, line)
    end
    for _, line in ipairs(E.find_multiline_test_each_lines()) do
        table.insert(result, line)
    end
    return result
end

function E.symbols_regexp()
    return '\\v(^async|^export|^function|^const|^let|^var|^class|^type|^interface)'
end

return E
