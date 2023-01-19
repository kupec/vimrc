local a = require('plenary.async')
local config_storage = require('config.storage')

local E = {}

local config_key = 'jira'

local default_jira_config = {
    base_url = "https://jira.com",
    default_jql = "project = ABC AND sprint IN openSprints() AND assignee = currentUser()",
}

E.init = a.void(function()
    local err, jira_config = config_storage.load(config_key)
    if err then
        print(err)
        return
    end

    if not jira_config then
        print('No config yet. Please edit')
        vim.defer_fn(E.edit_config_file, 0)
        return
    end

    print(jira_config.base_url)
end)

local function json_encode_pretty(obj)
    local pretty_print_code = table.concat({
        'import json',
        'import sys',
        'json.dump(json.load(sys.stdin), sys.stdout, indent=4)',
    }, '\n')
    return vim.fn.systemlist(
        vim.g.python3_host_prog .. ' -c ' .. vim.fn.shellescape(pretty_print_code),
        vim.fn.json_encode(obj)
    )
end

function E.edit_config_file()
    local file_path = config_storage.get_config_path(config_key)
    vim.cmd('new ' .. file_path)
    local text = json_encode_pretty(default_jira_config)
    vim.api.nvim_buf_set_lines(0, 0, 0, true, text)
end

return E
