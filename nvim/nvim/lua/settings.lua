local cmd = vim.cmd             -- execute Vim commands
local exec = vim.api.nvim_exec  -- execute Vimscript
local g = vim.g                 -- global variables
local opt = vim.opt             -- global/buffer/windows-scoped options

--opt.cursorline = true
opt.termguicolors = true
cmd'colorscheme onedark'
opt.number = true

opt.tabstop=4
opt.softtabstop=4
opt.shiftwidth=4
opt.expandtab = true
opt.so=999
g.onedark_termcolors=256

-- nvim-startify
vim.cmd('autocmd User Startified nunmap <buffer> t')

--- cmp
-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
vim.o.completeopt = 'menu,menuone,noselect'
-- luasnip setup
-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    snippet = {
      expand = function(args)
        require'luasnip'.lsp_expand(args.body)
      end
    },
    sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer', options = {
            get_bufnrs = function()
                return vim.api.nvim_list_bufs()
            end},
    	},
    },
    mapping = {
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<TAB>"] = cmp.mapping.confirm { select = true },
        ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
        ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
        ["<C-h>"] = cmp.mapping.scroll_docs(-4),
        ["<C-l>"] = cmp.mapping.scroll_docs(4),
    },
}

--- lspconfig

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

require('lspconfig').gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require('lspconfig').pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}



--- autosave
local autosave = require("autosave")

autosave.setup(
    {
        enabled = true,
        execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
        events = {"InsertLeave", "TextChanged"},
        conditions = {
            exists = true,
            filename_is_not = {},
            filetype_is_not = {},
            modifiable = true
        },
        write_all_buffers = false,
        on_off_commands = true,
        clean_command_line_interval = 0,
        debounce_delay = 135
    }
)


--- nvim-tree
local tree_cb = require'nvim-tree.config'.nvim_tree_callback

require'nvim-tree'.setup {
      disable_netrw       = true,
      hijack_netrw        = true,
      open_on_setup       = true,
      ignore_ft_on_setup  = {},
      update_to_buf_dir   = {
        enable = true,
        auto_open = true,
      },
      auto_close          = true,
      open_on_tab         = false,
      hijack_cursor       = false,
      update_cwd          = false,
      diagnostics         = {
        enable = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        }
      },
      update_focused_file = {
        enable      = false,
        update_cwd  = false,
        ignore_list = {}
      },
      system_open = {
        cmd  = nil,
        args = {}
      },
      view = {
        width = 30,
        height = 30,
        side = 'right',
        auto_resize = true,
        mappings = {
          custom_only = false,
          list = {
              { key = "u",        cb = tree_cb("dir_up") },
              { key = "b",        cb = tree_cb("cd") },
        }
      },
      filters = {
	dotfiles = true,
	custom = { '.git', 'node_modules', '.cache', '.vscode' }
    }
  }
}
local g = vim.g

g.nvim_tree_highlight_opened_files = 2 
g.nvim_quit_on_open = 1

---

--- tree-sitter
require'nvim-treesitter.configs'.setup {
    -- Modules and its options go here
  highlight = { enable = true },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
  locals = { enable = true },

}

--- nvim-gps

local gps = require("nvim-gps")
gps.setup()

--- lualine

local lualine = require("lualine")

lualine.setup({
	options = { theme = "jellybeans" },
	sections = {
		lualine_a = {
			{
				"filename",
				file_status = true, -- Displays file status (readonly status, modified status)
				path = 0, -- 0: Just the filename
				-- 1: Relative path
				-- 2: Absolute path

				shorting_target = 40, -- Shortens path to leave 40 spaces in the window
				-- for other components. (terrible name, any suggestions?)
				symbols = {
					modified = "[+]", -- Text to show when the file is modified.
					readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
					unnamed = "[No Name]", -- Text to show for unnamed buffers.
				},
			},
		},
		lualine_c = {
			{ gps.get_location, cond = gps.is_available },
		},
	},
})
