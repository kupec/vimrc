local os_detector = require 'utils.os_detector'
local each = require 'tests.each'

local original_os = jit.os
describe('os_detector', function ()
    after_each(function ()
        jit.os = original_os
    end)

    each({
        {'Linux', 'linux'},
        {'Windows', 'windows'},
    }).it('get_os $1 -> $2', function (jit_os, expected_os)
        jit.os = jit_os

        assert.equals(expected_os, os_detector.get_os())
    end)

    each({
        {'Linux', true},
        {'OSX', false},
        {'Windows', false},
    }).it('is_linux $1 -> $2', function (jit_os, expected)
        jit.os = jit_os

        assert.equals(expected, os_detector.is_linux())
    end)

    each({
        {'Linux', false},
        {'OSX', true},
        {'Windows', false},
    }).it('is_macos $1 -> $2', function (jit_os, expected)
        jit.os = jit_os

        assert.equals(expected, os_detector.is_macos())
    end)

    each({
        {'Linux', false},
        {'OSX', false},
        {'Windows', true},
    }).it('is_windows $1 -> $2', function (jit_os, expected)
        jit.os = jit_os

        assert.equals(expected, os_detector.is_windows())
    end)

    each({
        {'Linux', true},
        {'OSX', true},
        {'Windows', false},
    }).it('is_posix $1 -> $2', function (jit_os, expected)
        jit.os = jit_os

        assert.equals(expected, os_detector.is_posix())
    end)
end)
