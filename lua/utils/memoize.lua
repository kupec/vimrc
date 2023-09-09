return function(fn)
    local cache = {}

    return function(arg)
        if not cache[arg] then
            local result = fn(arg)
            cache[arg] = {result = result}
        end

        return cache[arg].result
    end
end
