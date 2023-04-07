local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values

local E = {}

function E.find_lines_by_regexp(regexp)
    local old_pos = vim.fn.getcurpos()
    vim.fn.cursor(1, 1)

    local items = {}

    while true do
        local line_nr = vim.fn.search(regexp, 'W')
        if line_nr == 0 then
            break
        end

        local line = vim.fn.getline(line_nr)
        table.insert(items, {line_nr, line})
    end

    vim.fn.setpos('.', old_pos)

    return items
end

function E.prepare_lines(regexp_or_list)
    local lines
    if type(regexp_or_list) ~= 'table' then
        lines = E.find_lines_by_regexp(regexp_or_list)
    else
        lines = regexp_or_list
    end

    table.sort(lines, function(a, b)
        if b[1] < a[1] then
            return true
        end
        return false
    end)

    return lines
end

function E.show_file_lines(regexp_or_list)
    local opts = {}

    pickers.new(opts, {
        prompt_title = 'Select line',
        finder = finders.new_table {
            results = E.prepare_lines(regexp_or_list),
            entry_maker = function(value)
                return {
                    value = value,
                    display = value[2],
                    ordinal = value[2],
                    path = vim.fn.expand('%'),
                    lnum = value[1],
                    col = 1,
                }
            end,
        },
        sorter = conf.generic_sorter(opts),
        previewer = conf.grep_previewer(opts),
        layout_config = {width = 0.9, height = 0.9},
    }):find()
end

return E
