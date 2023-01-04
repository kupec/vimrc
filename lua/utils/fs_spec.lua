local a = require'plenary.async'
local fs = require'utils.fs'
local assert_helper = require'tests.assert'

a.tests.add_to_env()

describe('fs', function ()
    a.it('async_scan_dir_to_list', function ()
        local path = vim.fn.stdpath('config') .. '/lua/tests/testdata/scan_dir'
        local error, result = fs.async_scan_dir_to_list(path)

        assert.is_nil(error)
        assert_helper.assert_equals(result, {'1', '2'})
    end)
end)
