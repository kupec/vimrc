local a = require'plenary.async'
local partial = require'plenary.functional'.partial

local E = {}

function E.async_scan_dir_to_list_cb(path, callback)
    vim.loop.fs_scandir(tostring(path), function (err, fs)
        if err then
            return vim.defer_fn(partial(callback, err), 0)
        end

        local iter = function()
            return vim.loop.fs_scandir_next(fs)
        end

        local result = {}
        for item in iter do
            table.insert(result, item)
        end

        vim.defer_fn(function()
            callback(nil, result)
        end, 0)
    end)
end

E.async_scan_dir_to_list = a.wrap(E.async_scan_dir_to_list_cb, 2)

return E
