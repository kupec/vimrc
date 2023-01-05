local E = {}

function E.find_fd_prog()
    if vim.fn.executable('fd') == 1 then
        return 'fd'
    end

    return 'fdfind'
end

return E
