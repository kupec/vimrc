local executables = require 'utils.executables'
local as_shell_script = require 'utils.as_shell_script'

local E = {}

function E.check_and_exit()
    as_shell_script.do_and_exit(function()
        local output = E.run_formatter {'--check'}
        if not next(output) then
            print('All files are good formatted')
            return 0
        end

        print('Files with wrong formatting:')
        for _, line in ipairs(output) do
            print(line)
        end
        return 1
    end)
end

function E.format_and_exit()
    as_shell_script.do_and_exit(function()
        E.run_formatter {'-i'}
        return 0
    end)
end

function E.run_formatter(options)
    local output = {}
    local base_cmd = E.make_base_formatter_cmd(options)

    local lua_files = E.find_lua_files()
    for _, lua_file in ipairs(lua_files) do
        local cmd = vim.deepcopy(base_cmd)
        table.insert(cmd, lua_file)

        local result = vim.fn.systemlist(cmd)
        for _, line in ipairs(result) do
            table.insert(output, line)
        end
    end

    return output
end

function E.make_base_formatter_cmd(options)
    local jit_version = string.gsub(jit.version, 'LuaJIT ', '')
    local cache_path = vim.fn.stdpath 'cache'

    local luarocks_prog = table.concat(
        {cache_path, 'packer_hererocks', jit_version, 'bin', 'lua-format'},
        '/'
    )

    local cmd = {luarocks_prog}
    table.insert(cmd, '--config=luaformatter.config')
    for _, opt in ipairs(options) do
        table.insert(cmd, opt)
    end
    table.insert(cmd, '--')

    return cmd
end

function E.find_lua_files()
    return vim.fn.systemlist {
        executables.find_fd_prog(),
        '--type', 'file',
        '\\.lua$'

    }
end

return E
