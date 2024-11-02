return {
    'lewis6991/gitsigns.nvim',
    config = function()
        require('gitsigns').setup({})
        vim.cmd('highlight GitSignsDelete guifg=#FF0000')
        vim.cmd('highlight GitSignsChange guifg=#0000FF')
        vim.cmd('highlight GitSignsAdd guifg=#00FF00')
    end
}
