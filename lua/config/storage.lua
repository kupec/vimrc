local a = require('plenary.async')

local E = {}

function E.get_config_path(file_name)
    local data_dir = vim.fn.stdpath('data')
    return data_dir .. '/' .. file_name
end

local function run_vim_fn(fn, ...)
    local args = {...}
    return a.wrap(function (callback)
        vim.defer_fn(function ()
            print('args', vim.inspect(args))
            callback(fn(unpack(args)))
        end, 0)
    end, 1)()
end

function E.load(file_name)
    local config_path = E.get_config_path(file_name)
    local err, fd = a.uv.fs_open(config_path, 'r', 384)
    if err then
        if string.find(err, 'ENOENT') == 1 then
            return nil, nil
        end
        return err
    end

    local err, stat = a.uv.fs_fstat(fd)
    if err then
        return err
    end

    local err, data = a.uv.fs_read(fd, stat.size, 0)
    if err then
        return err
    end

    local err = a.uv.fs_close(fd)
    if err then
        return err
    end

    return nil, run_vim_fn(vim.fn.json_decode, data)
end

E.save = a.wrap(function(file_name, config)
    local data = run_vim_fn(vim.fn.json_encode, config)

    local config_path = E.get_config_path(file_name)
    local err, fd = a.uv.fs_open(config_path, 'w')
    if err then
        return err
    end

    local err = a.uv.fs_write(fd, data)
    if err then
        return err
    end

    local err = a.uv.fs_close(fd)
    if err then
        return err
    end
end, 2)


return E
