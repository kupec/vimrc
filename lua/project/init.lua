local builtin = require "telescope.builtin"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_set = require "telescope.actions.set"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local make_entry = require "telescope.make_entry"

local E = {}

local possible_projects_dirs = {"~/proj", "~/projects"}

function E.open_project(path)
    vim.cmd('tcd ' .. path)
    vim.cmd 'new'
    vim.cmd 'execute "normal \\<c-w>o"'

    local win_width = vim.api.nvim_win_get_width(0)
    local win_height = vim.api.nvim_win_get_height(0)

    local valign = {}
    for i=1, win_height / 3 - 1 do
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
            return vim.fn.expand(dir)
        end
    end
end

function E.select_project_and_run(sink, opts)
    opts = opts or {}
    opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

    local projects_dir = get_projects_dir()
    local find_cmd = {
        vim.g.fd_prog,
        '.', projects_dir,
        '--type', 'd',
        '--max-depth', '1',
    }

    pickers.new(opts, {
        prompt_title = 'Select project',
        finder = finders.new_oneshot_job(find_cmd, opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr)
            action_set.select:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                sink(selection[1])
            end)
            return true
        end,
    }):find()
end

function E.select_tab_by_project(opts)
    opts = opts or {}

    local tab_info_list = vim.fn.gettabinfo()
    local source = {}
    for _, info in ipairs(tab_info_list) do
        local dir = vim.fn.getcwd(-1, info.tabnr)
        local projects_dir = get_projects_dir()
        local short_dir, count = string.gsub(dir, '^' .. projects_dir .. '/', '')
        if count == 1 then
            table.insert(source, {
                tabnr = info.tabnr,
                dir = dir,
                short_dir = short_dir,
            })
        end
    end

    if #source == 0 then
        return
    end

    pickers.new(opts, {
        prompt_title = 'Select tab by project',
        finder = finders.new_table {
          results = source,
          entry_maker = function(value)
              return {
                  value = value,
                  display = value.short_dir,
                  ordinal = value.short_dir,
              }
          end,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local tabnr = selection.value.tabnr
                vim.cmd(tabnr .. 'tabnext')
            end)

            local function find_files_in_project_directory()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                builtin.find_files {cwd = selection.value.dir}
                vim.cmd 'normal a'
            end

            map('i', '<c-o>', find_files_in_project_directory)

            return true
        end,
    }):find()
end

return E
