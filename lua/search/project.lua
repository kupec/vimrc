local builtin = require 'telescope.builtin'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local action_set = require 'telescope.actions.set'
local action_state = require 'telescope.actions.state'
local conf = require('telescope.config').values
local make_entry = require 'telescope.make_entry'
local themes = require('telescope.themes')

local E = {}

local possible_projects_dirs = {'~/proj', '~/projects'}

function E.open_project(path)
    vim.cmd('tcd ' .. path)
    vim.cmd 'new'
    vim.cmd 'execute "normal \\<c-w>o"'

    local win_width = vim.api.nvim_win_get_width(0)
    local win_height = vim.api.nvim_win_get_height(0)

    local valign = {}
    for i = 1, win_height / 3 - 1 do
        valign[i] = ''
    end
    vim.api.nvim_buf_set_lines(0, 0, 0, true, valign)

    vim.api.nvim_buf_set_lines(0, #valign, #valign, true, {'Project: ' .. path, 'Please open a file'})
    vim.cmd('$-2,$center ' .. win_width)
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'wipe'
end

function E.open_project_in_new_tab(path)
    local pwd = vim.fn.getcwd()
    vim.cmd('tcd ' .. pwd)

    vim.cmd 'tabnew'

    E.open_project(path)
end

local function get_projects_dir()
    for _, dir in ipairs(possible_projects_dirs) do
        if vim.fn.glob(dir) ~= '' then
            return vim.fn.expand(dir)
        end
    end
end

local function find_files_in_project_directory(prompt_bufnr)
    actions.close(prompt_bufnr)

    local selection = action_state.get_selected_entry()
    local cwd = selection.value
    if cwd.dir then
        cwd = cwd.dir
    end

    builtin.find_files {cwd = cwd}

    -- due to <c-o> mapping
    vim.cmd 'normal a'
end

function E.select_project_and_run(sink, opts)
    opts = opts or themes.get_dropdown()
    opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

    local projects_dir = get_projects_dir()
    local find_cmd = {vim.g.fd_prog, '.', projects_dir, '--type', 'd', '--max-depth', '1'}

    pickers.new(opts, {
        prompt_title = 'Select project',
        finder = finders.new_oneshot_job(find_cmd, opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            action_set.select:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                sink(selection[1])
            end)

            map('i', '<c-o>', find_files_in_project_directory)

            return true
        end,
    }):find()
end

local function find_buffers_in_project_tab(prompt_bufnr)
    actions.close(prompt_bufnr)

    local selection = action_state.get_selected_entry()
    local tab = selection.value.tabnr
    local windows = vim.api.nvim_tabpage_list_wins(tab)
    local file_list = {}
    for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        local file = vim.api.nvim_buf_get_name(buf)
        if #file > 0 then
            table.insert(file_list, file)
        end
    end

    if #file_list == 0 then
        print 'No opened file buffers in the project tab'
        return
    end

    local opts = {}
    pickers.new(opts, {
        prompt_title = 'Select opened file',
        finder = finders.new_table {results = file_list},
        sorter = conf.file_sorter(opts),
    }):find()
end

function E.select_tab_by_project(opts)
    opts = opts or themes.get_dropdown()

    local tab_info_list = vim.fn.gettabinfo()
    local source = {}
    for _, info in ipairs(tab_info_list) do
        local dir = vim.fn.getcwd(-1, info.tabnr)
        local projects_dir = get_projects_dir()
        local short_dir, count = string.gsub(dir, '^' .. projects_dir .. '/', '')
        if count == 1 then
            table.insert(source, {tabnr = info.tabnr, dir = dir, short_dir = short_dir})
        end
    end

    if #source == 0 then
        print 'No tabs with opened projects'
        return
    end

    pickers.new(opts, {
        prompt_title = 'Select tab by project',
        finder = finders.new_table {
            results = source,
            entry_maker = function(value)
                return {value = value, display = value.short_dir, ordinal = value.short_dir}
            end,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            action_set.select:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local tabnr = selection.value.tabnr
                vim.cmd(tabnr .. 'tabnext')
            end)

            map('i', '<c-o>', find_files_in_project_directory)
            map('i', '<c-p>', find_buffers_in_project_tab)

            return true
        end,
    }):find()
end

return E
