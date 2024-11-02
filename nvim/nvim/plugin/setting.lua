local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local api = vim.api

local utils = require('custom.utils')
local navic = require("nvim-navic")

local Path = require("plenary.path")

local HOME = Path:new(os.getenv("HOME"))
local ARCADIA = Path:new(os.getenv("ARCADIA"))


opt.cursorline = true
opt.showtabline = 0

opt.smartcase = true
opt.ignorecase = true

opt.termguicolors = true
opt.splitright = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

opt.shada = { "'10", "<0", "s10", "h" }

opt.clipboard = "unnamedplus"

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.so = 999
opt.autoread = true
g.onedark_termcolors = 256
cmd([[colorscheme tokyonight-night]])



local window_managment = api.nvim_create_augroup("WindowManagement", { clear = true })
api.nvim_create_autocmd("WinEnter", {
    callback = function()
        vim.opt_local.winhighlight = "Normal:NormalContrast,NormalNC:NormalNC"
    end,
    group = window_managment,
})


local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.diagnostic.config({
    virtual_text = {
        source = "always", -- Or "if_many"
    },
    float = {
        source = "always", -- Or "if_many"
    },
})

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
    -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
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
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

    require("lsp_signature").on_attach({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {
            border = "rounded"
        }
    }, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

require('lspconfig').taplo.setup({
    on_attach = on_attach,
})

-- require('lspconfig').ruff_lsp.setup {
--     on_attach = function(client) client.server_capabilities.hoverProvider = false end,
--     init_options = {
--         settings = {
--             args = {
--                 '--line-length=120',
--             },
--         }
--     }
-- }

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

local util = require("lspconfig.util")

require('lspconfig').gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    -- cmd = {'gopls', '-logfile=auto', '-remote.logfile=auto', '-debug=:0', '-rpc.trace', '-vv'},
    -- cmd = {'gopls', '-logfile=/tmp/gopls.log', '-vv'},
    cmd = utils.yandex_project_path() and { "ya", "tool", "gopls" } or { "gopls" },
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
            -- directoryFilters = filter,
            expandWorkspaceToModule = true,
        },
    }
}

require('go').setup()

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
require('lspconfig').kotlin_language_server.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require('lspconfig').yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require('lspconfig').ts_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require('lspconfig').rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

vim.env.PYTHONPATH = tostring(ARCADIA)
vim.env.Y_PYTHON_SOURCE_ROOT = tostring(ARCADIA)
vim.env.Y_PYTHON_ENTRY_POINT = ":main"
vim.env.DB_USE_ARCADIA_RECIPE = "False"



local function get_python_extra_path()
    local extraPaths = { tostring(ARCADIA), '', }

    for _, p in pairs({
        ARCADIA:joinpath('contrib/python/Babel'),
        ARCADIA:joinpath('contrib/python/XlsxWriter/py3'),
        ARCADIA:joinpath('contrib/python/aiohttp-cors'),
        ARCADIA:joinpath('contrib/deprecated/python/aiosocksy'),
        ARCADIA:joinpath('contrib/python/aiozipkin'),
        ARCADIA:joinpath('contrib/python/yarl'),
        ARCADIA:joinpath('contrib/python/inflection/py3'),
        ARCADIA:joinpath('contrib/python/transitions'),
        ARCADIA:joinpath('contrib/python/uvloop'),
        ARCADIA:joinpath('contrib/python/uvloo'),
        ARCADIA:joinpath('contrib/python/Jinja2'),
        ARCADIA:joinpath('contrib/python/xhtml2pdf'),
        ARCADIA:joinpath('contrib/python/pytest/py3'),
        ARCADIA:joinpath('contrib/python/PyHamcrest/py3'),
        ARCADIA:joinpath('metrika/uatraits/data'),
        ARCADIA:joinpath('metrika/uatraits/python'),
        ARCADIA:joinpath('pay/contrib/marshmallow-dataclass'),
        ARCADIA:joinpath('pay/lib/entities'),
        ARCADIA:joinpath('pay/lib/interactions'),
        ARCADIA:joinpath('pay/lib/tvm'),
        ARCADIA:joinpath('pay/lib/utils'),

    }) do
        table.insert(extraPaths, tostring(p))
    end

    for _, b in pairs({
        ARCADIA:joinpath('library/python/runtime_py3'),
        ARCADIA:joinpath('library/python/runtime_py3/main'),
        ARCADIA:joinpath('library/python/testing/import_test'),
        ARCADIA:joinpath('library/python/pyscopg2'),
        ARCADIA:joinpath('library/python/resource'),
        ARCADIA:joinpath('mail/python/sendr_qtools/src'),
        ARCADIA:joinpath('contrib/python/sentry-sdk/sentry_sdk/integrations/aiohttp'),
        ARCADIA:joinpath('contrib/python/psycopg2/psycopg'),
        ARCADIA:joinpath('mail/contrib/python/aiopg/aiopg/sa'),
        ARCADIA:joinpath('mail/contrib/python/aiopg/aiopg'),
        ARCADIA:joinpath('contrib/python/sqlalchemy/sqlalchemy-1.2'),
        ARCADIA:joinpath('contrib/python/PyHamcrest/hamcrest'),

    }) do
        table.insert(extraPaths, tostring(b))
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
                ignore = { '*' },         -- Using Ruff
                typeCheckingMode = 'off', -- Using mypy
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                extraPaths = get_python_extra_path(),
            }
        },
        pyright = {
            disableOrganizeImports = true, -- Using Ruff
        },
    }
}

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
            -- goto_next_start = {
            --     ["<C-l>"] = { query = "@function.outer", desc = "Next function start" },
            --     ["]c"] = { query = "@class.outer", desc = "Next class start" },
            -- },
            -- goto_previous_start = {
            --     ["<C-k>"] = { query = "@function.outer", desc = "Previous function start" },
            --     ["[c"] = { query = "@class.outer", desc = "Previous class start" },
            -- },
        }
    }

})


--vim.filetype.add({
--    filename = {
--        ['ya.make'] = 'yamake',
--    },
--})

--local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
--parser_config.yamake = {
--    install_info = {
--        url = "~/Projects/private/tree-sitter-yamake",
--        files = {
--            "src/parser.c",
--            "src/scanner.cc",
--            "queries/highlights.scm",
--        },
--       branch = "main",
--      generate_requires_npm = false,
--     requires_generate_from_grammar = false,
--    },
-- filetype = 'yamake'
--}

-- if opt.diff:get() then
--     api.nvim_set_hl(0, 'DiffAdd', {cterm={bold=true}, ctermfg=10, ctermbg=17})
--     api.nvim_set_hl(0, 'DiffDelete', {cterm={bold=true}, ctermfg=10, ctermbg=17})
--     api.nvim_set_hl(0, 'DiffChange', {cterm={bold=true}, ctermfg=10, ctermbg=17})
--     api.nvim_set_hl(0, 'DiffText', {cterm={bold=true}, ctermfg=10, ctermbg=88})
-- end
--
local null_ls = require('null-ls')

null_ls.setup({
    sources = {
        -- null_ls.builtins.formatting.isort,
        -- null_ls.builtins.formatting.black.with({
        --     extra_args = { "--line-length", "120", "--skip-string-normalization" },
        -- }),
        -- null_ls.builtins.formatting.autoflake.with({ extra_args = {
        --     '--remove-all-unused-imports'
        -- } }),
        -- require("none-ls.diagnostic.flake8"),
        require("none-ls.diagnostics.ruff"),
        require("none-ls.formatting.ruff_format"),
        require("none-ls.formatting.ruff"),
        null_ls.builtins.diagnostics.mypy,
        require("none-ls.formatting.jq"),
        null_ls.builtins.formatting.yamlfmt,
        -- null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.sql_formatter.with({
            extra_args = {
                '--language=postgresql', "-c", vim.fn.expand("~/.config/sql-formatter/config.json")
            }
        }),
    },
    on_attach = on_attach,
})

if utils.is_arcadia_repo() then
    require("sg").setup {
        -- Pass your own custom attach function
        --    If you do not pass your own attach function, then the following maps are provide:
        --        - gd -> goto definition
        --        - gr -> goto references
        on_attach = on_attach
    }
end
