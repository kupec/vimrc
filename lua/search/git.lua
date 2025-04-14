local builtin = require 'telescope.builtin'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local previewers = require 'telescope.previewers'
local putils = require 'telescope.previewers.utils'
local actions = require 'telescope.actions'
local action_set = require 'telescope.actions.set'
local action_state = require 'telescope.actions.state'
local conf = require('telescope.config').values
local make_entry = require 'telescope.make_entry'
local themes = require('telescope.themes')

local E = {}

function E.select_file_in_commit(commit, opts)
    opts = opts or themes.get_dropdown()
    opts.entry_maker = make_entry.gen_from_file(opts)

    local git_ls_command = {'git', 'ls-tree', '--name-only', '-r', commit}
    local git_cat_command = function(filepath)
        return {'git', 'show', commit .. ':' .. filepath}
    end

    local previewer = previewers.new_buffer_previewer {
        title = 'File in commit ' .. commit .. ' Preview',
        get_buffer_by_name = function(_, entry)
            return entry.value
        end,

        define_preview = function(self, entry)
            local cmd = git_cat_command(entry.value)

            putils.job_maker(cmd, self.state.bufnr, {value = entry.value, bufname = self.state.bufname, cwd = opts.cwd})
        end,
    }

    pickers.new(opts, {
        prompt_title = 'Files in commit ' .. commit,
        finder = finders.new_oneshot_job(git_ls_command, opts),
        previewer = {previewer},
        sorter = conf.generic_sorter(opts),
        attach_mappings = function()
            action_set.select:replace(function(prompt_bufnr, type)
                actions.close(prompt_bufnr)

                local entry = action_state.get_selected_entry()
                local result = vim.system(git_cat_command(entry.value)):wait()
                if result.code ~= 0 then
                    print('Cannot get file ' .. entry.value .. ', git returns: ' .. result.stderr)
                    return
                end

                local buf_create_cmd = action_state.select_key_to_edit_key(type)
                vim.cmd(buf_create_cmd)
                vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result.stdout, '\n'))
                vim.api.nvim_buf_set_name(0, commit .. ':' .. entry.value)
                vim.bo.buftype = 'nofile'
                vim.bo.bufhidden = 'wipe'
                vim.cmd('filetype detect')
            end)
            return true
        end,
    }):find()
end

function E.select_git_commit(opts)
    opts = opts or themes.get_dropdown()
    opts.entry_maker = make_entry.gen_from_git_commits(opts)
    opts.maximum_results = 10000

    local git_command = {'git', 'log', '--oneline', '--decorate', '--all'}

    pickers.new(opts, {
        prompt_title = 'Git commits',
        finder = finders.new_oneshot_job(git_command, opts),
        previewer = {previewers.git_commit_message.new(opts)},
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            action_set.select:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                E.select_file_in_commit(selection.value)
            end)
            return true
        end,
    }):find()
end

return E
