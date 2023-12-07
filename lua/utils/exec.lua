local E = {}

function E.exec_sync(cmd, opts)
    opts = opts or {}
    local timeout = opts.timeout or 2000

    local stdout, stderr
    local job = vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function (_, s)
            stdout = s
        end,
        on_stderr = function (_, s)
            stderr = s
        end,
    })
    if job == 0 then
        error('Invalid arguments for jobstart -', vim.inspect(cmd))
    elseif job == -1 then
        error('"Is not executable" in jobstart -', vim.inspect(cmd))
    end

    local exit_code_list = vim.fn.jobwait({job}, timeout)
    local exit_code = exit_code_list[1]
    if exit_code < 0 then
        error('Timeout in jobwait or something else, cmd = ', vim.inspect(cmd))
    end

    return {
        exit_code = exit_code,
        stdout = stdout,
        stderr = stderr,
    }
end

return E
