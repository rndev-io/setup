local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local set = vim.keymap.set

vim.g.mapleader = ','


-- map('v', '<C-r>', 'hy:%s/<C-r>h//gc<left><left><left>', default_opts) -- replace selected text

-- map('', ';', 'l', default_opts)
-- map('', 'l', 'j', default_opts)
-- map('', 'k', 'k', default_opts)
-- map('', 'j', 'h', default_opts)

-- ## split movements

-- map('', '<up>', ':echoe "Use l"<CR>', default_opts)
-- map('', '<down>', ':echoe "Use k"<CR>', default_opts)
-- map('', '<left>', ':echoe "Use j"<CR>', default_opts)
-- map('', '<right>', ':echoe "Use ;"<CR>', default_opts)

-- map('n', '<C-k>', '<Cmd>wincmd k<CR>', default_opts)
-- map('n', '<C-l>', '<Cmd>wincmd j<CR>', default_opts)
-- map('n', '<C-j>', '<Cmd>wincmd h<CR>', default_opts)
-- map('n', '<C-;>', '<Cmd>wincmd l<CR>', default_opts)

-- map('n', '<C-k>', '<Cmd>wincmd k<CR>', default_opts)
-- map('n', '<C-j>', '<Cmd>wincmd j<CR>', default_opts)
-- map('n', '<C-h>', '<Cmd>wincmd h<CR>', default_opts)
-- map('n', '<C-l>', '<Cmd>wincmd l<CR>', default_opts)

-- set("n", "<c-j>", "<c-w><c-j>")
-- set("n", "<c-k>", "<c-w><c-k>")
-- set("n", "<c-l>", "<c-w><c-l>")
-- set("n", "<c-h>", "<c-w><c-h>")

map("v", "<", "<gv", default_opts)
map("v", ">", ">gv", default_opts)

map("n", "<C-o>", "Go", default_opts)

set("n", "<Esc>", function()
    ---@diagnostic disable-next-line: undefined-field
    if vim.opt.hlsearch:get() then
        vim.cmd.nohl()
        return ""
    else
        return "<CR>"
    end
end, { expr = true })

-- toggleterm
-- map("t", "<Esc>", [[<C-\><C-n>]], {})
--
-- set("n", "]d", vim.diagnostic.goto_next)
-- set("n", "[d", vim.diagnostic.goto_prev)

--- telescope
--map('n', 'ff', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], default_opts)
--map('n', 'fg', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], default_opts)
set('n', 'fd', function() require('telescope.builtin').lsp_diagnostic() end, default_opts)
set('n', 'fr', function() require('telescope.builtin').lsp_references({ show_line = false }) end, default_opts)

set('n', '<leader>c', function() require('telescope.builtin').commands() end, default_opts)

-- map('n', 'fs', [[<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>]], default_opts)

--- nvim-tree
-- vim.api.nvim_set_keymap(
--     "n",
--     "tt",
--     ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
--     { noremap = true }
-- )

-- clipboard
map("v", "<leader>y", '"+y', default_opts)
map("v", "<leader>p", '"+p', default_opts)

-- luasnip
-- local luasnip = require('luasnip')
-- local cmp = require("cmp")

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- _G.tab_complete = function()
--     if cmp and cmp.visible() then
--         cmp.select_next_item()
--     elseif luasnip and luasnip.expand_or_jumpable() then
--         return t("<Plug>luasnip-expand-or-jump")
--     elseif check_back_space() then
--         return t "<Tab>"
--     else
--         cmp.complete()
--     end
--     return ""
-- end
--
-- _G.s_tab_complete = function()
--     if cmp and cmp.visible() then
--         cmp.select_prev_item()
--     elseif luasnip and luasnip.jumpable(-1) then
--         return t("<Plug>luasnip-jump-prev")
--     else
--         return t "<S-Tab>"
--     end
--     return ""
-- end

-- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
-- vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})

-- text-case
set('n', 'gas', function() require('textcase').current_word('to_snake_case') end, { desc = 'Convert to_snake_case' })
set('v', 'gas', function() require('textcase').current_word('to_snake_case') end, { desc = 'Convert to_snake_case' })

-- quickfix
set('n', '<C-n>', [[<cmd>cnf<cr>]], { desc = 'Next item in quickfix' })
set('n', '<C-p>', [[<cmd>cpf<cr>]], { desc = 'Previous item in quickfix' })

-- rub lua
set('n', '<space><space>x', '<cmd>source %<CR>')
set('n', '<space>x', ':.lua<CR>')
set('v', '<space>x', ':lua<CR>')

-- windows.nvim
-- local function cmd(command)
--    return table.concat({ '<Cmd>', command, '<CR>' })
-- end
--
-- vim.keymap.set('n', 'zz', cmd 'WindowsMaximize', {desc = 'Windows Maximize'})
