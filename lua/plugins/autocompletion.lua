local cmp = require('cmp')

--vim.cmd 'set completeopt=menu,menuone,noselect'

cmp.setup {
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                ultisnips = "[UltiSnips]",
                nvim_lua = "[Lua]",
                look = "[Look]",
                path = "[Path]",
                spell = "[Spell]",
            })[entry.source.name]
            return vim_item
        end
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        }),
    },
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end
    },
    sources = {
        {name = 'buffer'},
        {name = "path"},
        {name = 'nvim_lsp'},
        {name = "nvim_lua"},
        {name = "ultisnips"},
        {name = "look"},
        {name = "spell"},
    },
    completion = {completeopt = 'menu,menuone,noselect'}
}
