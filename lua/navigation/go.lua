local E = {}

function E.tests_regexp()
    return '\\vfunc .* Test'
end

function E.symbols_regexp()
    return '\\vfunc|type'
end

return E
