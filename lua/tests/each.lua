local a = require'plenary.async'

local make_test_name = function(test_pattern, params, test_index)
    for index, param in ipairs(params) do
        test_pattern = string.gsub(test_pattern, '$' .. index, tostring(param))
    end

    return test_pattern .. ' #' .. test_index
end

local each = function(test_params_list)
    local make_it = function(it)
        return function (test_pattern, test_func)
            for test_index, params in ipairs(test_params_list) do
                it(make_test_name(test_pattern, params, test_index), function ()
                    test_func(unpack(params))
                end)
            end
        end
    end

    return {
        it = make_it(it),
        ait = make_it(a.it),
    }
end

return each
