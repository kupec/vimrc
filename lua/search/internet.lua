local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_set = require "telescope.actions.set"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local themes = require('telescope.themes')

local E = {}

local internet_sources = {
    {'google', 'https://www.google.com/search?q=%s'},
    {'mdn docs', 'https://developer.mozilla.org/en-US/search?q=%s'},
    {'npm package', 'https://www.npmjs.com/package/%s'},
    {'python docs', 'https://docs.python.org/3/search.html?check_keywords=yes&area=default&q=%s'},
    {'pypi package', 'https://pypi.org/search/?q=%s'},
    {'github', 'https://github.com/search?q=%s'},
}

function E.find_cword_on_site(site_fmt)
    local cmd = vim.split(vim.g.netrw_browsex_viewer, '%s+')

    local cword = vim.fn.expand '<cword>'
    if #cword == 0 then
        print('No word under the cursor')
        return
    end

    table.insert(cmd, string.format(site_fmt, cword))
    vim.fn.system(cmd)
end

function E.find_cword_on_any_site(opts)
    opts = opts or themes.get_cursor()

    local cword = vim.fn.expand '<cword>'
    if #cword == 0 then
        print('No word under the cursor')
        return
    end

    pickers.new(opts, {
        prompt_title = 'Select internet source',
        finder = finders.new_table {
          results = internet_sources,
          entry_maker = function(value)
              local name, url = unpack(value)
              return {
                  value = url,
                  display = name,
                  ordinal = name,
              }
          end,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr)
            action_set.select:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                E.find_cword_on_site(selection.value)
            end)
            return true
        end,
    }):find()
end

return E
