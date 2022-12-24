local E = {}

function E.assert_array_equals(actual, expected)
    assert.equals(
        #expected,
        #actual,
        'Expected array with length=' .. #expected .. 
        ' but see array with length=' .. #actual .. 
        '\n\n' .. vim.inspect({actual=actual, expected=expected})
    )

    for index, actual_item in ipairs(actual) do
        expected_item = expected[index]
        assert.equals(
            expected_item,
            actual_item,
            'Different item on index ' .. index ..
            ' , ' .. actual_item .. ' != ' .. expected_item ..
            '\n\n' .. vim.inspect({actual=actual, expected=expected})
        )
    end
end

return E
