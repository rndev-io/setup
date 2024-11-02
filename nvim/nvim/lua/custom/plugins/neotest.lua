return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "rusnasonov/neotest-python",
        "nvim-neotest/neotest-go",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local utils = require('custom.utils')
        local group = vim.api.nvim_create_augroup("NeotestOutput", { clear = true })
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
