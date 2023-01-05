local utils = require 'navigation.utils'
local each = require 'tests.each'
local assert_helper = require 'tests.assert'

describe('navigation utils', function()
    each({
        {{}, {}},
        {{{1, 'qwe'}, {2, 'rty'}}, {{2, 'rty'}, {1, 'qwe'}}},
        {{{2, 'qwe'}, {1, 'rty'}}, {{2, 'qwe'}, {1, 'rty'}}},
    }).it('prepare_lines $1 -> $2', function(input, expected)
        local actual = utils.prepare_lines(input)
        assert_helper.assert_equals(actual, expected)
    end)
end)
