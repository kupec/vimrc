local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_set = require "telescope.actions.set"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values

local E = {}

local internet_sources = {
    {'google', 'https://www.google.com/search?q=%s'},
    {'mdn docs', 'https://developer.mozilla.org/en-US/search?q=%s'},
    {'npm package', 'https://www.npmjs.com/package/%s'},
    {'python docs', 'https://docs.python.org/3/search.html?check_keywords=yes&area=default&q=%s'},
    {'pypi package', 'https://pypi.org/search/?q=%s'},
}

function E.find_cword_on_site(site_fmt)
    local cmd = {}
    for token in string.gmatch(vim.g.netrw_browsex_viewer, '%S+') do
        table.insert(cmd, token)
    end

    local cword = vim.fn.expand '<cword>'
    table.insert(cmd, string.format(site_fmt, cword))

    vim.fn.system(cmd)
end

function E.find_cword_on_any_site(opts)
    opts = opts or {}

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
