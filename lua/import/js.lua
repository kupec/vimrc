local Job = require'plenary.job'
local Path = require'plenary.path'
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_set = require "telescope.actions.set"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local themes = require('telescope.themes')

local E = {}

local lib_tokens_map = {
    ['classnames'] = 'clsx',
    ['immer'] = 'produce',
    ['@material-ui/core'] = '{}',
    ['mockdate'] = 'MockDate',
    ['prop-types'] = 'PropTypes',
    ['react'] = 'React',
    ['react-redux'] = '{useSelector, useDispatch}',
    ['react-router-dom'] = '{Link, useHistory, useLocation, useParams}',
    ['@testing-library/react'] = '{render, act, fireEvent}',
    ['ts-jest'] = {'{mocked}', 'ts-jest/utils'},
    ['type-fest'] = '{PromiseValue}',
}

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
        attach_mappings = E.make_mapping_for_insert_import_statement {
            parse = E.parse_path_for_import,
        },
    }):find()
end

function E.make_mapping_for_insert_import_statement(options)
    local parse = options.parse

    return function(prompt_bufnr, map)
        local function handler(options)
            options = vim.tbl_extend('force', {
                after = false,
                kind = 'import',
            }, options)

            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            local path = selection[1]

            if options.kind == 'import' then
                local import_tokens, import_path = parse(path)
                E.insert_js_import_statement(import_tokens, import_path, options)
            end
        end

        action_set.select:replace(function() handler({after = false}) end)
        map('i', '<c-d>', function() handler({after = true}) end)

        return true
    end
end

function E.parse_path_for_import(path)
    local rel_path = E.get_import_js_file_path(path)
    local base_file_name = vim.fn.fnamemodify(rel_path, ":p:t:r")
    return base_file_name, rel_path
end

function E.insert_js_import_statement(import_tokens, import_path, options)
    local import_statement = string.format("import %s from '%s'", import_tokens, import_path)
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

function E.find_package_json()
    local cur_dir = Path:new(vim.fn.expand("%:h"))

    for _, dir in ipairs(cur_dir:parents()) do
        local package_json_path = tostring(Path:new(dir) / 'package.json')
        if vim.fn.filereadable(package_json_path) == 1 then
            return vim.fn.json_decode(vim.fn.readfile(package_json_path))
        end
    end

    error('Cannot find package.json', 2)
end

function E.import_js_lib(opts)
    opts = opts or themes.get_cursor()

    local source = {}
    local package_json = E.find_package_json()
    vim.list_extend(source, vim.tbl_keys(package_json.dependencies or {}))
    vim.list_extend(source, vim.tbl_keys(package_json.devDependencies or {}))

    pickers.new(opts, {
        prompt_title = 'Select lib to import',
        finder = finders.new_table {results = source},
        sorter = conf.generic_sorter(opts),
        attach_mappings = E.make_mapping_for_insert_import_statement {
            parse = E.parse_lib_for_import,
        },
    }):find()
end

function E.parse_lib_for_import(name)
    local import_path = name
    local import_tokens = lib_tokens_map[name]
    if not import_tokens then
        import_tokens = name
    end

    if type(import_tokens) == 'table' then
        import_tokens, import_path = unpack(import_tokens)
    end

    return import_tokens, import_path
end


return E
