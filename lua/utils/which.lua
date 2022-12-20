local os_detector = require 'utils.os_detector'

return function(exe)
    if os_detector.is_posix() then
        return vim.fn.system(
            {'which', exe}
        )
    elseif os_detector.is_windows() then
        return vim.trim(vim.fn.system(
            {'powershell', '-Command', '-'},
            '(Get-Command ' .. exe ' | Select-Object).Source'
        ))
    end
end
