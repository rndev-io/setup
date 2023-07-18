local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}
local set = vim.keymap.set

vim.g.mapleader = ','

-- map('', '<up>', ':echoe "Use l"<CR>', default_opts)
-- map('', '<down>', ':echoe "Use k"<CR>', default_opts)
-- map('', '<left>', ':echoe "Use j"<CR>', default_opts)
-- map('', '<right>', ':echoe "Use ;"<CR>', default_opts)

map('n', '<esc>', ':noh<return><esc>', default_opts)  -- clear search highlight by pressing esc


-- map('v', '<C-r>', 'hy:%s/<C-r>h//gc<left><left><left>', default_opts) -- replace selected text

map('', ';', 'l', default_opts)
map('', 'l', 'j', default_opts)
map('', 'k', 'k', default_opts)
map('', 'j', 'h', default_opts)

map('n', '<up>', ':wincmd k<CR>', default_opts)
map('n', '<down>', ':wincmd j<CR>', default_opts)
map('n', '<left>', ':wincmd h<CR>', default_opts)
map('n', '<right>', ':wincmd l<CR>', default_opts)
-- map('n', '<M-2>', ':2wincmd w<CR>', default_opts)
-- map('n', '<M-3>', ':3wincmd w<CR>', default_opts)
-- map('n', '<M-4>', ':4wincmd w<CR>', default_opts)

map("v", "<", "<gv", default_opts)
map("v", ">", ">gv", default_opts)

map("n", "<C-o>", "Go", default_opts)

-- toggleterm
map("t", "<Esc>", [[<C-\><C-n>]], {})

--- telescope
--map('n', 'ff', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], default_opts)
--map('n', 'fg', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], default_opts)
set('n', 'fd', function() require('telescope.builtin').lsp_diagnostic() end, default_opts)
set('n', 'fr', function() require('telescope.builtin').lsp_references({show_line=false}) end, default_opts)

set('n', '<leader>c', function() require('telescope.builtin').commands() end, default_opts)

-- map('n', 'fs', [[<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>]], default_opts)

map('v', '<C-f>', 'y<ESC>:Telescope live_grep default_text=<c-r>0<CR>', default_opts)

--- nvim-tree
vim.api.nvim_set_keymap(
  "n",
  "tt",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true }
)

-- clipboard
map("v", "<leader>y", '"+y', default_opts)
map("v", "<leader>p", '"+p', default_opts)

-- twilight
map("n", "tw", ":Twilight<CR>", default_opts)

-- telekasten
local telekasten = require("telekasten")

set('n', '<leader>zf', telekasten.find_notes)
set('n', '<leader>zd', telekasten.find_daily_notes)
set('n', '<leader>zg', telekasten.search_notes)
set('n', '<leader>zz', telekasten.follow_link)
set('n', '<leader>zn', telekasten.new_note)
set('n', '<leader>zb', telekasten.show_backlinks)
set('n', '<leader>z', telekasten.panel)

-- harpoon
set('n', "<leader>a", function() require("harpoon.mark").add_file() end)
set('n', "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end)
set('n', "<C-j>", function() require("harpoon.ui").nav_prev() end)                  -- navigates to next mark
set('n', "<C-;>", function() require("harpoon.ui").nav_next() end)                   -- navigates to next mark
-- set('n', '<M-1>', function() require("harpoon.ui").nav_file(1) end)
-- set('n', '<M-2>', function() require("harpoon.ui").nav_file(2) end)
-- set('n', '<M-3>', function() require("harpoon.ui").nav_file(3) end)
-- set('n', '<M-4>', function() require("harpoon.ui").nav_file(4) end)

-- luasnip
local luasnip = require('luasnip')
local cmp = require("cmp")

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

_G.tab_complete = function()
    if cmp and cmp.visible() then
        cmp.select_next_item()
    elseif luasnip and luasnip.expand_or_jumpable() then
        return t("<Plug>luasnip-expand-or-jump")
    elseif check_back_space() then
        return t "<Tab>"
    else
        cmp.complete()
    end
    return ""
end

_G.s_tab_complete = function()
    if cmp and cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip and luasnip.jumpable(-1) then
        return t("<Plug>luasnip-jump-prev")
    else
        return t "<S-Tab>"
    end
    return ""
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})

-- text-case
set('n', 'gas', function() require('textcase').current_word('to_snake_case') end, { desc = 'Convert to_snake_case'})
set('v', 'gas', function() require('textcase').current_word('to_snake_case') end, { desc = 'Convert to_snake_case'})

-- windows.nvim
-- local function cmd(command)
--    return table.concat({ '<Cmd>', command, '<CR>' })
-- end
--
-- vim.keymap.set('n', 'zz', cmd 'WindowsMaximize', {desc = 'Windows Maximize'})

