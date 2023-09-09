local memoize = require 'utils.memoize'
local each = require 'tests.each'

describe('memoize', function()
    it('call function once', function()
        local fn = memoize(function(x)
            return x + 1
        end)

        assert.equals(fn(1), 2)
        assert.equals(fn(2), 3)
    end)

    it('call function twice', function()
        local fn = memoize(function(x)
            return x + 1
        end)

        assert.equals(fn(1), 2)
        assert.equals(fn(1), 2)
    end)

    it('call function with side effect', function()
        local acc = 0
        local fn = memoize(function(x)
            acc = acc + 1
            return x + acc
        end)

        assert.equals(fn(1), 2)
        assert.equals(fn(1), 2)
        assert.equals(fn(2), 4)
    end)
end)
