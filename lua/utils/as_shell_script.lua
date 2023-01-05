local E = {}

function E.exit(code)
    print('\n')
    code = code or 0
    vim.cmd(tostring(code) .. 'cquit')
end

function E.do_and_exit(fn)
    local code = fn()
    E.exit(code)
end

return E
