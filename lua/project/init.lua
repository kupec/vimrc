local E = {}

local possible_projects_dirs = {"~/proj", "~/projects"}

function E.open_project(path)
    vim.cmd('tcd ' .. path)
    vim.cmd 'new'

    local win_width = vim.api.nvim_win_get_width(0)
    local win_height = vim.api.nvim_win_get_height(0)

    local valign = {}
    for i=1, win_height / 2 - 1 do
        valign[i] = ''
    end
    vim.api.nvim_buf_set_lines(0, 0, 0, true, valign)

    vim.api.nvim_buf_set_lines(0, #valign, #valign, true, {
        'Project: ' .. path,
        'Please open a file',
    })
    vim.cmd('$-2,$center ' .. win_width)
    vim.bo.modified = false
    vim.bo.modifiable = false

    vim.cmd 'execute "normal \\<c-w>o"'
end

function E.open_project_in_new_tab(path)
    local pwd = vim.fn.getcwd()
    vim.cmd('tcd ' .. pwd)

    vim.cmd 'tabnew'

    E.open_project(path)
end

local function get_projects_dir()
    for _, dir in ipairs(possible_projects_dirs) do
        if vim.fn.glob(dir) ~= "" then
            return dir
        end
    end
end

function E.select_project_and_run(sink)
    local projects_dir = get_projects_dir()

    vim.fn['fzf#run']({
        source = vim.g.fd_prog .. ' . ' .. projects_dir .. ' --type d --max-depth 1',
        sink = sink,
        options = {'--preview', 'cat {}/README.md'},
    })
end

return E
