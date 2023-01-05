local E = {}

function E.get_type(value)
    local t = type(value)
    if t == 'table' and value[1] then
        return 'array'
    end

    return t
end

function E.assert_equals(actual, expected, key_path)
    key_path = key_path or {}

    assert.equals(E.get_type(expected), E.get_type(actual), 'Different types' .. '\n\n' ..
                      vim.inspect({actual = actual, expected = expected, key_path = key_path}))

    local _type = E.get_type(actual)

    if _type == 'table' then
        E.assert_table_equals(actual, expected, key_path)
    elseif _type == 'array' then
        E.assert_array_equals(actual, expected, key_path)
    else
        local assert_prefix = ''
        if next(key_path) ~= nil then
            assert_prefix = 'Different values on path ' .. table.concat(key_path, '.') .. '\n\n'
        end

        assert.equals(expected, actual,
                      assert_prefix .. vim.inspect({actual = actual, expected = expected, key_path = key_path}))
    end
end

function E.assert_array_equals(actual, expected, key_path)
    key_path = key_path or {}

    assert.equals(#expected, #actual,
                  'Expected array with length=' .. #expected .. ' but see array with length=' .. #actual .. '\n\n' ..
                      vim.inspect({actual = actual, expected = expected, key_path = key_path}))

    for index, actual_item in ipairs(actual) do
        local expected_item = expected[index]

        local next_key_path = {}
        for _, v in ipairs(key_path) do
            table.insert(next_key_path, v)
        end
        table.insert(next_key_path, index)

        E.assert_equals(actual_item, expected_item, next_key_path)
    end
end

function E.assert_table_equals(actual, expected, key_path)
    key_path = key_path or {}

    local all_keys = {}
    for key, _ in pairs(actual) do
        all_keys[key] = 1
    end
    for key, _ in pairs(expected) do
        all_keys[key] = 1
    end

    for _, key in ipairs(all_keys) do
        local actual_value = actual[key]
        local expected_value = expected[key]

        local next_key_path = {}
        for _, v in ipairs(key_path) do
            table.insert(next_key_path, v)
        end
        table.insert(next_key_path, key)

        E.assert_equals(actual_value, expected_value, next_key_path)
    end
end

return E
