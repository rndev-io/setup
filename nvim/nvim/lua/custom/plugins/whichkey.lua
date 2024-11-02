return {
    "folke/which-key.nvim",
    config = function()
        local wk = require("which-key")
        local utils = require('custom.utils')

        wk.setup({})

        wk.add({
            mode = { 'n' },
            { 'f',  group = "find" },
            {
                'ff',
                function()
                    local text = ''
                    require('telescope.builtin').find_files({ default_text = text })
                end,
                desc = "Find File"
            },
            { 'fg', function() require('telescope').extensions.live_grep_args.live_grep_args() end,                       desc = "Live Grep" },
            { 'fw', function() require('telescope-live-grep-args.shortcuts').grep_word_under_cursor() end,                desc = "Live Grep Word Under Cursor" },
            { 'fs', function() require('telescope-live-grep-args.shortcuts').grep_word_under_cursor_current_buffer() end, desc = "Live Grep Word Under Cursor in Current Buffer" },
            {
                'fo',
                function()
                    require('telescope.builtin').lsp_dynamic_workspace_symbols({
                        symbols = { "class",
                            "function" }
                    })
                end,
                desc = "Objects"
            },
        })

        wk.add({
            mode = { 'v' },
            { 'f', group = 'find' },
            {
                'fg',
                function()
                    require('telescope-live-grep-args.shortcuts').grep_visual_selection()
                    -- local text = vim.getVisualSelection()
                    -- require('telescope').extensions.live_grep_args.live_grep_args({ default_text = text })
                    -- require("telescope.builtin").live_grep({ default_text = text })
                end,
                desc = "Grep Word"
            },
            {
                'ff',
                function()
                    local text = vim.getVisualSelection()
                    -- local buff_name = vim.api.nvim_buf_get_name(0)
                    -- if buff_name:find("toggleterm#") then
                    --     -- go to top buffer
                    --     vim.cmd('wincmd k')
                    -- end
                    require('telescope.builtin').find_files({ default_text = text })
                end,
                desc = "Find File"
            },
        })

        wk.add({
            mode = { 'n' },
            { '<leader>t', group = 'tests' },
            { 'tr',        function() require("neotest").run.run() end,                         desc = "run nearest test" },
            { 'tu',        function() require("neotest").run.run(utils.tests_path('unit')) end, desc = "run all unit test" },
            {
                'tf',
                function() require("neotest").run.run(utils.tests_path('functional')) end,
                desc = "run all functional test"
            },
            { 'to', function() require("neotest").output.open({ enter = true }) end,    desc = "show test output" },
            { 'ts', function() require("neotest").summary.toggle() end,                 desc = "show tests summary" },
            { 'tp', function() require("neotest").jump.prev({ status = "failed" }) end, desc = "jump to previous failed test" },
            { 'tn', function() require("neotest").jump.next({ status = "failed" }) end, desc = "jump to next failed test" },
            { 'ta', function() require("neotest").run.run(vim.fn.expand('%')) end,      desc = "run all in current file" },
        })

        wk.add({ { '<leader>a', [[<cmd>AerialToggle!<CR>]], desc = "Aerial Toggle" } })

        wk.add({
            -- Utils Group
            { "<leader>u",  group = "utils" },
            { "<leader>uc", "<cmd>TextCaseOpenTelescope<CR>",                  desc = "Text Case", mode = { "n", "v" } },

            -- Merge Group
            { "<leader>m",  group = "merge" },
            { "<leader>mr", "<cmd>diffget _REMOTE<CR>",                        desc = "Remote" },
            { "<leader>ml", "<cmd>diffget _LOCAL<CR>",                         desc = "Local" },

            -- Harpoon Group
            { "<leader>h",  group = "harpoon" },
            { "<leader>ha", function() require("harpoon.mark").add_file() end, desc = "Add" },
        })
    end
}
