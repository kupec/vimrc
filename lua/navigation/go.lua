local E = {}

function E.tests_regexp()
    return '\\vfunc .* Test|^\\s*[nN]ame: *".*",'
end

function E.symbols_regexp()
    return '\\vfunc|type'
end

return E
