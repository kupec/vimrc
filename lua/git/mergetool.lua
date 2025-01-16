local E = {}

function E.show_diff(buffer_pattern)
    local left_buf_nr = 0
    local right_buf_nr = 0

    for _, buf in ipairs(vim.fn.getbufinfo({buflisted = 1})) do
        if string.find(buf.name, 'BASE') then
            left_buf_nr = buf.bufnr
        end
        if string.find(buf.name, buffer_pattern) then
            right_buf_nr = buf.bufnr
        end
    end

    vim.cmd('tabnew')
    vim.cmd('buffer ' .. left_buf_nr)
    vim.cmd('diffthis')
    vim.cmd('vertical sbuffer ' .. right_buf_nr)
    vim.cmd('diffthis')
end

function E.show_local_diff()
    E.show_diff('LOCAL')
end

function E.show_remote_diff()
    E.show_diff('REMOTE')
end

return E
