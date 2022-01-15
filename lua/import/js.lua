local Job = require'plenary.job'
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_set = require "telescope.actions.set"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local themes = require('telescope.themes')

local E = {}

function E.import_js_file(search_root, opts)
    search_root = search_root or vim.fn.getcwd()
    opts = opts or themes.get_cursor()

    local find_cmd = {
        vim.g.fd_prog,
        '.', search_root,
        '--type', 'f',
    }

    pickers.new(opts, {
        prompt_title = 'Select file to import',
        finder = finders.new_oneshot_job(find_cmd, opts),
        sorter = conf.file_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            local function handler(options)
                options = vim.tbl_extend('force', {
                    after = false,
                    kind = 'import',
                }, options)

                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local path = selection[1]

                if options.kind == 'import' then
                    E.insert_js_import_statement(path, options)
                end
            end

            action_set.select:replace(function() handler({after = false}) end)
            map('i', '<c-d>', function() handler({after = true}) end)

            return true
        end,
    }):find()
end

function E.insert_js_import_statement(path, options)
    local rel_path = E.get_import_js_file_path(path)
    local base_file_name = vim.fn.fnamemodify(rel_path, ":p:t:r")

    local import_statement = string.format("import %s from '%s'", base_file_name, rel_path)
    vim.api.nvim_put({import_statement}, 'l', options.after, not options.after)
end

function E.get_import_js_file_path(path)
    local rel_path
    if vim.startswith(path, 'node_modules/') then
        rel_path = string.gsub(path, '^node_modules/', '')
    else
        rel_path = E.get_relative_path(path)

        if not vim.startswith(rel_path, '.') then
            rel_path = './' .. rel_path
        end
    end

    local ext_list = {'js', 'jsx', 'ts', 'tsx'}
    for _, ext in ipairs(ext_list) do
        rel_path = string.gsub(rel_path, '%.' .. ext .. '$', '')
    end

    return rel_path
end

function E.get_relative_path(file_path)
    local cur_path = vim.fn.expand('%:p:h')
    file_path = vim.fn.fnamemodify(file_path, ':p')

    local result = Job:new({
        command = 'realpath',
        args = {'-m', '--relative-to', cur_path, file_path},
    }):sync()

    return vim.trim(result[1])
end

return E
