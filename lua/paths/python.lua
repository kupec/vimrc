local memoize = require('utils.memoize')
local util = require('lspconfig/util')
local exec = require('utils.exec')
local path = util.path

local E = {}

function E.get_python_path(workspace)
    local venv = E.get_python_virtual_env(workspace)
    if not venv then
        return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
    end

    print('Found python virtual env -', venv)
    return path.join(venv, 'bin', 'python')
end

local venv_variants = {
    {'poetry.lock', 'poetry env info -p'},
    {
        'Pipfile',
        function(match)
            return 'PIPENV_PIPFILE=' .. match .. ' pipenv --venv'
        end,
    },
}

E.get_python_virtual_env = memoize(function(workspace)
    if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV
    end

    for _, variant in ipairs(venv_variants) do
        local key_file, get_venv_path_cmd = unpack(variant)
        if type(get_venv_path_cmd) == 'string' then
            local value = get_venv_path_cmd
            get_venv_path_cmd = function(_)
                return value
            end
        end

        local match = vim.fn.glob(path.join(workspace, key_file))
        if match ~= '' then
            local cmd = get_venv_path_cmd(match)
            local result = exec.exec_sync(cmd)
            if result.exit_code ~= 0 then
                print(
                    'Cannot find python because of cmd = <', cmd, '>',
                    'returns code=', result.exit_code,
                    'and stderr is ', result.stderr
                )
            end

            return vim.fn.trim(result.stdout[1])
        end
    end
end)

return E
