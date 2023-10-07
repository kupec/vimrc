local E = {}

function E.get_visual_selection()
    local _, ls, cs = unpack(vim.fn.getpos('v'))
    local _, le, ce = unpack(vim.fn.getpos('.'))
    if ls > le or (ls == le and cs > ce) then
        ls, cs, le, ce = le, ce, ls, cs
    end

    local lines = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
    return table.concat(lines, '\n')
end

function E.get_word_under_cursor()
    return vim.fn.expand '<cword>'
end

function E.get_smart_selection()
    local mode = vim.fn.mode():sub(1, 1)
    if mode == 'v' or mode == 'V' then
        return E.get_visual_selection()
    end

    return E.get_word_under_cursor()
end

return E
