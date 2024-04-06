vim.cmd([[packadd packer.nvim]])

require('plugins.bufferline')
require('plugins.comment')
require('plugins.gitsigns')
require('plugins.telescope')
require('plugins.which-key')
require('plugins.harpoon')

return require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use { "nvim-neotest/nvim-nio" }
    use 'joshdick/onedark.vim'
    use 'folke/tokyonight.nvim'
    -- use 'marko-cerovac/material.nvim'
    -- use 'andrewradev/linediff.vim'
    use { "williamboman/mason.nvim", config = function()
        require("mason").setup()
    end }

    use { 'windwp/nvim-spectre', config = function()
        require('spectre').setup()
    end }

    use { "williamboman/mason-lspconfig.nvim", config = function()
        require("mason-lspconfig").setup()
    end }

    -- use { 'nvim-tree/nvim-web-devicons', config = function() require('nvim-web-devicons').setup() end }
    use { 'nvim-lualine/lualine.nvim' }
    use { 'akinsho/bufferline.nvim', tag = "*" }

    use { 'andythigpen/nvim-coverage', requires = 'nvim-lua/plenary.nvim' }
    use { 'renerocksai/telekasten.nvim' }
    use { "johmsalas/text-case.nvim",
        config = function()
            require('textcase').setup {}
        end
    }
    use {
        '~/Projects/yandex/arcadia/junk/perseus/nvim-yandex', run = 'make'
    }
    use 'scrooloose/vim-slumlord'

    use 'aklt/plantuml-syntax'
    -----------------------------------------------------------
    -- НАВИГАЦИЯ
    -----------------------------------------------------------
    -- Файловый менеджер
    use 'majutsushi/tagbar'
    -- Замена fzf и ack
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-live-grep-args.nvim',
        },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end
    }
    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }
    use { "folke/which-key.nvim" }
    -- use { 'ThePrimeagen/harpoon', config = function()
    --     require("harpoon").setup()
    -- end }
    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { "nvim-lua/plenary.nvim" }
    }
    -----------------------------------------------------------
    -- LSP и автодополнялка
    -----------------------------------------------------------
    use {
        'ray-x/go.nvim'
    }
    use {
        "ray-x/lsp_signature.nvim",
    }
    use { 'nvimtools/none-ls.nvim', requires = { "nvimtools/none-ls-extras.nvim" } }

    use {
        "mfussenegger/nvim-dap",
        opt = true,
        event = "BufReadPre",
        module = { "dap" },
        wants = { "nvim-dap-virtual-text", "nvim-dap-ui", "nvim-dap-python", "which-key.nvim" },
        requires = {
            "theHamsta/nvim-dap-virtual-text",
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap-python",
            "nvim-telescope/telescope-dap.nvim",
            { "leoluz/nvim-dap-go", module = "dap-go" },
            { "jbyuki/one-small-step-for-vimkind", module = "osv" },
        },
        config = function()
            require("plugins.dap").setup()
        end,
    }

    -- Highlight, edit, and navigate code using a fast incremental parsing library
    use {
        "Exafunction/codeium.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({
            })
        end
    }
    use 'nvim-treesitter/nvim-treesitter'
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use {
        "SmiteshP/nvim-navic",
        requires = "neovim/nvim-lspconfig"
    }
    use "nvim-treesitter/playground"
    -- Collection of configurations for built-in LSP client
    use 'neovim/nvim-lspconfig'
    -- use 'williamboman/nvim-lsp-installer'
    -- Автодополнялка
    use { 'hrsh7th/nvim-cmp' }
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-cmdline'
    use 'onsails/lspkind-nvim'
    -- use 'hrsh7th/cmp-buffer'

    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use "rafamadriz/friendly-snippets"

    --- Автодополнлялка к файловой системе
    use 'hrsh7th/cmp-path'
    -- Snippets plugin
    -- подсветка только активного региона
    use {
        'numToStr/Comment.nvim',
    }

    use { "windwp/nvim-autopairs" }
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {
                use_diagnostic_signs = true
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    -- Даже если включена русская раскладка vim команды будут работать
    --use 'powerman/vim-plugin-ruscmd'
    use "Pocco81/auto-save.nvim"
    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "rusnasonov/neotest-python",
            "nvim-neotest/neotest-go",
        },
        config = function()
            local neotest_ns = vim.api.nvim_create_namespace("neotest")
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        local message =
                        diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                        return message
                    end,
                },
            }, neotest_ns)
        end,
    }
    use { 'lewis6991/gitsigns.nvim' }
end)
