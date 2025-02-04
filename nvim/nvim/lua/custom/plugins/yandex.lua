return {
    {
        dir = '~/Projects/yandex/arcadia/junk/perseus/yandex.nvim',
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            require('yandex').setup({})
        end
    }
}
