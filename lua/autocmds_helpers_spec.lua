local helpers = require 'autocmds_helpers'
local each = require 'tests.each'

describe('autocmds_helpers', function ()
    each({
        {'n', true},
        {'no', true},
        {'nov', true},
        {'noV', true},
        {'noCTRL-V', true},
        {'niI', true},
        {'niR', true},
        {'niV', true},
        {'nt', false},
        {'ntT', false},
        {'v', true},
        {'vs', true},
        {'V', true},
        {'Vs', true},
        {'CTRL-V', true},
        {'CTRL-Vs', true},
        {'s', true},
        {'S', true},
        {'CTRL-S', true},
        {'i', true},
        {'ic', false},
        {'ix', true},
        {'R', true},
        {'Rc', false},
        {'Rx', true},
        {'Rv', true},
        {'Rvc', false},
        {'Rvx', true},
        {'c', false},
        {'cv', false},
        {'r', false},
        {'rm', false},
        {'r?', false},
        {'!', false},
        {'t', false},
    }).it(
        'does_vim_mode_allow_file_changes mode=$1 - $2',
        function (mode, expected)
            local actual = helpers.does_vim_mode_allow_file_changes(mode)
            assert.equals(expected, actual)
        end
    )
end)
