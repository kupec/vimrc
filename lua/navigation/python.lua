local E = {}

function E.tests_regexp()
    return '\\vdef test_'
end

function E.symbols_regexp()
    return '\\v(<class>|<def>|^\\w+\\s*\\=)'
end

return E
