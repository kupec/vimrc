local E = {}

E.win = 'win'

function E.get_os()
    return string.lower(jit.os)
end

function E.is_linux()
    return E.get_os() == 'linux'
end

function E.is_macos()
    return E.get_os() == 'osx'
end

function E.is_windows()
    return E.get_os() == 'windows'
end

function E.is_posix()
    return E.is_linux() or E.is_macos()
end

return E
