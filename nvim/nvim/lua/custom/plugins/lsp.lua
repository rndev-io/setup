return {
    {'ray-x/go.nvim'},
    {'ray-x/guihua.lua'},
    {"ray-x/lsp_signature.nvim"},
    { 'nvimtools/none-ls.nvim', dependencies = { "nvimtools/none-ls-extras.nvim" } },
    {
        "Exafunction/codeium.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({
            })
        end
    },
    {'nvim-treesitter/nvim-treesitter'},
    {"nvim-treesitter/nvim-treesitter-textobjects"},
    {
        "SmiteshP/nvim-navic",
        dependencies = "neovim/nvim-lspconfig"
    },
    "nvim-treesitter/playground",
    {'neovim/nvim-lspconfig'},
    {'onsails/lspkind-nvim'}
}
