local memoize = require('utils.memoize')
local util = require('lspconfig/util')
local path = util.path

local E = {}

function E.get_python_path(workspace)
    local venv = E.get_python_virtual_env(workspace)
    if not venv then
        return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
    end

    return path.join(venv, 'bin', 'python')
end

local venv_variants = {
    {'poetry.lock', 'poetry env list --full-path'},
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
        print(match)
        if match ~= '' then
            local cmd = get_venv_path_cmd(match)
            print(cmd)
            print(vim.fn.system(cmd))
            return vim.fn.trim(vim.fn.system(cmd))
        end
    end
end)

return E
