return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lua',
            'saadparwaiz1/cmp_luasnip',
            {
                "L3MON4D3/LuaSnip",
                build = "make install_jsregexp",
                config = function()
                    require("luasnip/loaders/from_vscode").lazy_load()
                end
            },
            "rafamadriz/friendly-snippets"
        },
        config = function()
            require('custom.completion')
        end
    },
}
