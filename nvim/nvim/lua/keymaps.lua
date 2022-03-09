local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}

vim.g.mapleader = ','

map('', '<up>', ':echoe "Use k"<CR>', default_opts)
map('', '<down>', ':echoe "Use j"<CR>', default_opts)
map('', '<left>', ':echoe "Use h"<CR>', default_opts)
map('', '<right>', ':echoe "Use l"<CR>', default_opts)

--- telescope
map('n', 'ff', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], default_opts)
map('n', 'fg', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], default_opts)

--- nvim-tree
map('n', 'tf', ':NvimTreeFocus<CR>', default_opts)
map('n', 'tt', ':NvimTreeToggle<CR>', default_opts)

-- clipboard    
map("v", "<leader>y", '"+y', default_opts)
map("v", "<leader>p", '"+p', default_opts)
