local a = require'plenary.async'

local P = {}

function P.each(test_params_list)
    return P.multi_each {test_params_list}
end

function P.multi_each(test_params_list_groups)
    local make_it = function(it)
        local reduce = {}
        function reduce.test_func(test_pattern, test_func, iteration)
            local group_count = #test_params_list_groups
            local iter_number = #iteration
            if group_count == iter_number then
                it(P.make_test_name(test_pattern, iteration), function ()
                    local params = P.reduce_test_params(iteration)
                    test_func(unpack(params))
                end)
                return
            end

            local test_params_list = test_params_list_groups[iter_number + 1]
            for test_index, params in ipairs(test_params_list) do
                local next_iteration = vim.deepcopy(iteration)
                table.insert(next_iteration, {test_index, params})
                reduce.test_func(test_pattern, test_func, next_iteration)
            end
        end

        return function (test_pattern, test_func)
            reduce.test_func(test_pattern, test_func, {})
        end
    end

    local self = {}

    self.it = make_it(it)
    self.ait = make_it(a.it)

    function self.each(test_params_list)
        table.insert(test_params_list_groups, test_params_list)
        return self
    end

    return self
end

function P.reduce_test_params(iteration)
    local params = {}
    for _, item in ipairs(iteration) do
        local _, params_chunk = unpack(item)
        for _, param in ipairs(params_chunk) do
            table.insert(params, param)
        end
    end
    return params
end

function P.make_test_name(test_pattern, params_groups)
    local index = 1
    for _, item in ipairs(params_groups) do
        local _, params_chunk = unpack(item)
        for _, param in ipairs(params_chunk) do
            test_pattern = string.gsub(test_pattern, '$' .. index, vim.inspect(param))
            index = index + 1
        end
    end

    local test_indices = vim.tbl_map(function (item)
        local test_index, _ = unpack(item)
        return tostring(test_index)
    end, params_groups)

    return test_pattern .. ' #' .. table.concat(test_indices, ',')
end

return P.each
