local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local api = vim.api

local utils = require('utils')
local navic = require("nvim-navic")

local Path = require "plenary.path"

local HOME = Path:new(os.getenv("HOME"))
local ARCADIA = Path:new(os.getenv("ARCADIA"))


-- ##############
-- local arcadia = require('arcadia')

-- arcadia.setup({})

-- ###########

opt.cursorline = true -- Highlight the current line
opt.showtabline = 0

local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
    vim.api.nvim_create_autocmd(event, {
        group = group,
        pattern = pattern,
        callback = function()
            vim.opt_local.cursorline = value
        end,
    })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")

local window_managment = api.nvim_create_augroup("WindowManagement", { clear = true })
api.nvim_create_autocmd("WinEnter", {
    callback = function()
        vim.opt_local.winhighlight = "Normal:NormalContrast,NormalNC:NormalNC"
    end,
    group = window_managment,
})

api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*.py" },
    command = [[%s/\s\+$//e]],
})

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = "*",
    command = [[silent! :%foldopen!]],
})

opt.termguicolors = true

require('material').setup({
    contrast = {
        non_current_windows = false
    },
    high_visibility = {
        darker = true
    }
})

vim.g.material_style = "darker"

cmd('colorscheme material')

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.so = 999
opt.autoread = true
g.onedark_termcolors = 256


-- autocmd
--vim.api.nvim_create_autocmd("FileType", {
--    pattern = {"*"},
--    callback = function()
--        require("twilight").enable()
--    end
--})

-- nvim-startify
-- vim.cmd('autocmd User Startified nunmap <buffer> t')

--- nvim-autopairs
require("nvim-autopairs").setup({
    check_ts = true,
})

--- cmp
-- nvim-cmp supports additional completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.o.completeopt = 'menu,menuone,noselect'
-- luasnip setup

require("luasnip/loaders/from_vscode").load()

-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')
local compare = require('cmp.config.compare')

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local lspkind_comparator = function(conf)
    local lsp_types = require('cmp.types').lsp
    return function(entry1, entry2)
      if entry1.source.name ~= 'nvim_lsp' then
        if entry2.source.name == 'nvim_lsp' then
          return false
        else
          return nil
        end
      end
      local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
      local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

      local priority1 = conf.kind_priority[kind1] or 0
      local priority2 = conf.kind_priority[kind2] or 0
      if priority1 == priority2 then
        return nil
      end
      return priority2 < priority1
    end
end

local label_comparator = function(entry1, entry2)
    return entry1.completion_item.label < entry2.completion_item.label
end

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        -- { name = 'buffer', options = {
        --     get_bufnrs = function()
        --         return vim.api.nvim_list_bufs()
        --     end
        -- },
        -- },
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
        ["<up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
        ["<left>"] = cmp.mapping.scroll_docs(-4),
        ["<right>"] = cmp.mapping.scroll_docs(4),
    },
    sorting = {
        comparators = {
            compare.recently_used,
            lspkind_comparator({
              kind_priority = {
                Field = 11,
                Property = 11,
                Constant = 10,
                Enum = 10,
                EnumMember = 10,
                Event = 10,
                Function = 10,
                Method = 10,
                Operator = 10,
                Reference = 10,
                Struct = 10,
                Variable = 9,
                File = 8,
                Folder = 8,
                Class = 5,
                Color = 5,
                Module = 5,
                Keyword = 2,
                Constructor = 1,
                Interface = 1,
                Snippet = 0,
                Text = 1,
                TypeParameter = 1,
                Unit = 1,
                Value = 1,
              },
            }),
            label_comparator,
          },
    }
}

cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
        { { name = 'path' } },
        { { name = 'cmdline' } }
    )
})
--- lspconfig

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>', opts)
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

    require("lsp_signature").on_attach({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {
            border = "rounded"
        }
    }, bufnr)

    navic.attach(client, bufnr)
end

require('lspconfig').marksman.setup({
    on_attach = on_attach,
    filetypes = { 'markdown', 'telekasten' }
})

local filter = {
    "-library/python",
    "-library/cpp",
    "-contrib",
    "+contrib/go",
    "-sandbox",
    "-logfeller",
    "-kikimr/public/sdk/python",
    "-ydb/public/sdk/python",
}

if string.find(vim.api.nvim_buf_get_name(0), "/arcadia") == nil then
    filter = {}
end

local util = require "lspconfig.util"

require('lspconfig').gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    -- cmd = {'gopls', '-logfile=auto', '-remote.logfile=auto', '-debug=:0', '-rpc.trace', '-vv'},
    -- cmd = {'gopls', '-logfile=/tmp/gopls.log', '-vv'},
    cmd = { 'gopls', '-rpc.trace' },
    root_dir = util.root_pattern("ya.make", "go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            analyses = { unusedparams = true, unusedwrite = true, shadow = true },
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
            staticcheck = true,
            usePlaceholders = true,
            directoryFilters = filter,
            expandWorkspaceToModule = false,
        },
    }
}

require('go').setup()

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})

require('coverage').setup({
    lang = {
        python = {
        }
    }
})

require("lspconfig").jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { 'vscode-json-languageserver', '--stdio' }
}

require('lspconfig').lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

require('lspconfig').yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require('lspconfig').tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

vim.env.PYTHONPATH = tostring(ARCADIA)
vim.env.Y_PYTHON_SOURCE_ROOT = tostring(ARCADIA)
vim.env.Y_PYTHON_ENTRY_POINT = ":main"
vim.env.DB_USE_ARCADIA_RECIPE = "False"

require("neotest").setup({
    levels = 0,
    output = {
        open_on_run = false,
    },
    quickfix = {
        open = false,
    },
    adapters = {
        require("neotest-python")({
            -- Extra arguments for nvim-dap configuration
            dap = { justMyCode = false },
            -- Command line arguments for runner
            -- Can also be a function to return dynamic values
            args = { "--log-level", "DEBUG" },
            -- Runner to use. Will use pytest if available by default.
            -- Can be a function to return dynamic value.
            runner = "pytest",
            python = utils.python_path(),
        }),
        require("neotest-go"),
    }
})

local neotest_config_group = vim.api.nvim_create_augroup("NeotestConfig", {})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "neotest-output",
    group = group,
    callback = function(opts)
        vim.keymap.set("n", "q", function()
            pcall(vim.api.nvim_win_close, 0, true)
        end, {
            buffer = opts.buf,
        })
    end,
})

local function get_python_extra_path()
    local scan = require('plenary.scandir')

    local paths = {
        'library/python/symbols',
        'contrib/python',
    }
    local extraPaths = {tostring(ARCADIA), '',}

    for _, b in pairs({
        ARCADIA:joinpath('library/python/runtime_py3'),
        ARCADIA:joinpath('library/python/runtime_py3/main'),
        ARCADIA:joinpath('library/python/testing/import_test'),
        ARCADIA:joinpath('mail/python/sendr-qtools/src'),
        ARCADIA:joinpath('contrib/python/sentry-sdk/sentry_sdk/integrations/aiohttp'),
        ARCADIA:joinpath('contrib/python/psycopg2/psycopg'),
        ARCADIA:joinpath('mail/contrib/python/aiopg/aiopg/sa'),
        ARCADIA:joinpath('contrib/python/sqlalchemy/sqlalchemy-1.2'),
        ARCADIA:joinpath('contrib/python/PyHamcrest/hamcrest'),

    }) do
        table.insert(extraPaths, tostring(b))
    end
    for _, p in pairs(paths) do
        local curPath = Path:new(ARCADIA) / p
        local dirs = scan.scan_dir(tostring(curPath), {hidden=false, only_dirs=true, depth=1})
        for _, dir in pairs(dirs) do
            local d = Path:new(dir)
            if d:joinpath('py3'):exists() then
                table.insert(extraPaths, tostring(d:joinpath('py3')))
            else
                table.insert(extraPaths, tostring(d))
            end
        end
    end
    return extraPaths
end


require('lspconfig').pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = utils.yandex_project_path,
    settings = {
        python = {
            pythonPath = utils.python_path(),
            envFile = tostring(ARCADIA:parent():joinpath('.env')),
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                extraPaths = get_python_extra_path(),
            }
        }
    }
}



--- autosave
local autosave = require("auto-save")

autosave.setup(
    {
        enabled = true,
        execution_message = {
            message = function() -- message to print on save
                return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
            end,
            dim = 0.18,               -- dim the color of `message`
            cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
        },
        events = { "InsertLeave", "TextChanged" },
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

g.nvim_quit_on_open = 1

---

--- tree-sitter
require('nvim-treesitter.configs').setup({
    -- Modules and its options go here
    highlight = { enable = true },
    incremental_selection = { enable = true },
    locals = { enable = true },
    indent = {
        enable = true,
        disable = { "python", },
    },
    textobjects = {
        enable = true,
        move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              goto_next_start = {
                ["]m"] = { query = "@function.outer", desc = "Next function start"},
                ["]c"] = { query = "@class.outer", desc = "Next class start" },
              },
              goto_previous_start = {
                ["[m"] = { query = "@function.outer", desc = "Previous function start"},
                ["[c"] = { query = "@class.outer", desc = "Previous class start" },
              },
        }
    }

})

--- lualine

local lualine = require("lualine")

lualine.setup({
    options = { theme = "jellybeans" },
    sections = {
        lualine_a = {
            {
                "filename",
                file_status = true, -- Displays file status (readonly status, modified status)
                path = 1,           -- 0: Just the filename
                -- 1: Relative path
                -- 2: Absolute path

                shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                -- for other components. (terrible name, any suggestions?)
                symbols = {
                    modified = "[+]",      -- Text to show when the file is modified.
                    readonly = "[-]",      -- Text to show when the file is non-modifiable or readonly.
                    unnamed = "[No Name]", -- Text to show for unnamed buffers.
                },
            },
        },
        lualine_c = {
            { navic.get_location, cond = navic.is_available }
        },
    },
})

--- telekasten

local home = vim.fn.expand("~/Yandex.Disk.localized/Private/zettelkasten")
-- NOTE for Windows users:
-- - don't use Windows
-- - try WSL2 on Windows and pretend you're on Linux
-- - if you **must** use Windows, use "/Users/myname/zettelkasten" instead of "~/zettelkasten"
-- - NEVER use "C:\Users\myname" style paths
-- - Using `vim.fn.expand("~/zettelkasten")` should work now but mileage will vary with anything outside of finding and opening files
require('telekasten').setup({
    home                        = home,
    -- if true, telekasten will be enabled when opening a note within the configured home
    take_over_my_home           = true,
    -- auto-set telekasten filetype: if false, the telekasten filetype will not be used
    --                               and thus the telekasten syntax will not be loaded either
    auto_set_filetype           = true,
    -- dir names for special notes (absolute path or subdir name)
    dailies                     = home .. '/' .. 'daily',
    weeklies                    = home .. '/' .. 'weekly',
    templates                   = home .. '/' .. 'templates',
    -- image (sub)dir for pasting
    -- dir name (absolute path or subdir name)
    -- or nil if pasted images shouldn't go into a special subdir
    image_subdir                = "img",
    -- markdown file extension
    extension                   = ".md",
    -- Generate note filenames. One of:
    -- "title" (default) - Use title if supplied, uuid otherwise
    -- "uuid" - Use uuid
    -- "uuid-title" - Prefix title by uuid
    -- "title-uuid" - Suffix title with uuid
    new_note_filename           = "title",
    -- file uuid type ("rand" or input for os.date()")
    uuid_type                   = "%Y%m%d%H%M",
    -- UUID separator
    uuid_sep                    = "-",
    -- following a link to a non-existing note will create it
    follow_creates_nonexisting  = true,
    dailies_create_nonexisting  = true,
    weeklies_create_nonexisting = true,
    -- skip telescope prompt for goto_today and goto_thisweek
    journal_auto_open           = false,
    -- template for new notes (new_note, follow_link)
    -- set to `nil` or do not specify if you do not want a template
    template_new_note           = home .. '/' .. 'templates/new_note.md',
    -- template for newly created daily notes (goto_today)
    -- set to `nil` or do not specify if you do not want a template
    template_new_daily          = nil, -- home .. '/' .. 'templates',
    -- template for newly created weekly notes (goto_thisweek)
    -- set to `nil` or do not specify if you do not want a template
    template_new_weekly         = nil, -- home .. '/' .. 'templates/weekly.md',
    -- image link style
    -- wiki:     ![[image name]]
    -- markdown: ![](image_subdir/xxxxx.png)
    image_link_style            = "markdown",
    -- default sort option: 'filename', 'modified'
    sort                        = "filename",
    -- integrate with calendar-vim
    -- telescope actions behavior
    close_after_yanking         = false,
    insert_after_inserting      = true,
    -- tag notation: '#tag', ':tag:', 'yaml-bare'
    tag_notation                = "#tag",
    -- command palette theme: dropdown (window) or ivy (bottom panel)
    command_palette_theme       = "dropdown",
    -- tag list theme:
    -- get_cursor: small tag list at cursor; ivy and dropdown like above
    show_tags_theme             = "ivy",
    -- when linking to a note in subdir/, create a [[subdir/title]] link
    -- instead of a [[title only]] link
    subdirs_in_links            = true,
    -- template_handling
    -- What to do when creating a new note via `new_note()` or `follow_link()`
    -- to a non-existing note
    -- - prefer_new_note: use `new_note` template
    -- - smart: if day or week is detected in title, use daily / weekly templates (default)
    -- - always_ask: always ask before creating a note
    template_handling           = "always_ask",
    -- path handling:
    --   this applies to:
    --     - new_note()
    --     - new_templated_note()
    --     - follow_link() to non-existing note
    --
    --   it does NOT apply to:
    --     - goto_today()
    --     - goto_thisweek()
    --
    --   Valid options:
    --     - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
    --              all other ones in home, except for notes/with/subdirs/in/title.
    --              (default)
    --
    --     - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
    --                    except for notes with subdirs/in/title.
    --
    --     - same_as_current: put all new notes in the dir of the current note if
    --                        present or else in home
    --                        except for notes/with/subdirs/in/title.
    new_note_location           = "smart",
    -- should all links be updated when a file is renamed
    rename_update_links         = true,
})

vim.filetype.add({
  filename = {
    ['ya.make'] = 'yamake',
  },
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.yamake = {
  install_info = {
    url = "~/Projects/private/tree-sitter-yamake",
    files = {
        "src/parser.c",
        "src/scanner.cc",
        "queries/highlights.scm",
    },
    branch = "main",
    generate_requires_npm = false,
    requires_generate_from_grammar = false,
  },
  -- filetype = 'yamake'
}

if opt.diff:get() then
    -- api.nvim_set_hl(0, 'DiffAdd', {cterm={bold=true}, ctermfg=10, ctermbg=17})
    -- api.nvim_set_hl(0, 'DiffDelete', {cterm={bold=true}, ctermfg=10, ctermbg=17})
    -- api.nvim_set_hl(0, 'DiffChange', {cterm={bold=true}, ctermfg=10, ctermbg=17})
    -- api.nvim_set_hl(0, 'DiffText', {cterm={bold=true}, ctermfg=10, ctermbg=88})
end
