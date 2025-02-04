-- return {
--     {
--         'hrsh7th/nvim-cmp',
--         dependencies = {
--             'hrsh7th/cmp-nvim-lsp',
--             'hrsh7th/cmp-buffer',
--             'hrsh7th/cmp-path',
--             'hrsh7th/cmp-cmdline',
--             'hrsh7th/cmp-nvim-lua',
--             'saadparwaiz1/cmp_luasnip',
--             {
--                 "L3MON4D3/LuaSnip",
--                 build = "make install_jsregexp",
--                 config = function()
--                     require("luasnip/loaders/from_vscode").lazy_load()
--                 end
--             },
--             "rafamadriz/friendly-snippets"
--         },
--         config = function()
--             require('custom.completion')
--         end
--     },
-- }

return {
    'saghen/blink.cmp',

    dependencies = 'rafamadriz/friendly-snippets',

    version = '*',
    opts = {
        keymap = {
            preset = 'default',
            ['<Tab>'] = {
                'accept',
                'fallback'
            },
            ['<C-p>'] = { 'select_prev', 'fallback' },
            ['<C-n>'] = { 'select_next', 'fallback' },
            -- ['<CR>'] = { 'accept', 'fallback' },
            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        },
        completion = {
            -- list = { selection = 'auto_insert' },
            -- ghost_text = { enabled = true },
            menu = { auto_show = true }
        },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono'
        },
    },
}
