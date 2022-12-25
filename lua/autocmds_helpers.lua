local E = {}

function E.does_vim_mode_allow_file_changes(mode)
    local mode_regex = vim.regex('\\v(c|r.?|!|t)')
    return mode_regex:match_str(mode) == nil
end

return E
