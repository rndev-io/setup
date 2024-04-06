local wk = require("which-key")
local utils = require('utils')

wk.setup({})

wk.register({
    f = {
        name = "find", -- optional group name
        f = { [[<cmd>lua require('telescope.builtin').find_files()<cr>]], "Find File" },
        g = { [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>]], "Live Grep" },
        s = { [[<cmd>lua require('telescope.builtin').grep_string()<cr>]], "Grep Word" },
        o = { function() require('telescope.builtin').lsp_dynamic_workspace_symbols({ symbols = { "class", "function" } }) end,
            "Objects" },
    },
})

wk.register({
    f = {
        g = {
            function()
                local text = vim.getVisualSelection()
                require('telescope').extensions.live_grep_args.live_grep_args({ default_text = text })
                -- require("telescope.builtin").live_grep({ default_text = text })
            end,
            "Grep Word"
        },
    }
}, { mode = 'v' })

wk.register({
    t = {
        name = "tests",
        r = { function() require("neotest").run.run() end, "run nearest test" },
        u = { function() require("neotest").run.run(utils.tests_path('unit')) end, "run all unit test" },
        f = { function() require("neotest").run.run(utils.tests_path('functional')) end, "run all functional test" },
        o = { function() require("neotest").output.open({ enter = true }) end, "show test output" },
        s = { function() require("neotest").summary.toggle() end, "show tests summary" },
        p = { function() require("neotest").jump.prev({ status = "failed" }) end, "jump to previous failed test" },
        n = { function() require("neotest").jump.next({ status = "failed" }) end, "jump to next failed test" },
    }
}, { prefix = "<leader>" })

wk.register({
    u = {
        name = 'utils',
        c = { [[<cmd>TextCaseOpenTelescope<CR>]], "text case" }
    }
}, { prefix = '<leader>' })

wk.register({
    u = {
        name = 'utils',
        c = { [[<cmd>TextCaseOpenTelescope<CR>]], "text case" }
    }
}, { prefix = '<leader>', mode = 'v' })

wk.register({
    m = {
        name = "merge",
        r = { [[<cmd>diffget _REMOTE<CR>]], "Remote" },
        l = { [[<cmd>diffget _LOCAL<CR>]], "Local" },
    }
}, { prefix = "<leader>" })

wk.register({
    h = {
        name = "harpoon",
        a = { function() require("harpoon"):list():add() end, "Add" },
    }
}, { prefix = "<leader>" })
