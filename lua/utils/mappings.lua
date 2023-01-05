local function create_mapping_func(default_opts)
    return function(mode, lhs, rhs, override_opts)
        local opts = {}
        for k, v in pairs(default_opts) do
            opts[k] = v
        end
        for k, v in pairs(override_opts or {}) do
            opts[k] = v
        end

        vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
    end
end

return {noremap = create_mapping_func {noremap = true, silent = true}, map = create_mapping_func {silent = true}}

