return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-live-grep-args.nvim',
        },
        config = function()
            -- local lga_actions = require("telescope-live-grep-args.actions")

            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = {
                        "__pycache__"
                    }
                },
                extensions = {
                    file_browser = {
                        hijack_netrw = false,
                    },
                    -- live_grep_args = {
                    --     mappings = { -- extend mappings
                    --         i = {
                    --             ["<C-k>"] = lga_actions.quote_prompt(),
                    --             ["<C-t>"] = lga_actions.quote_prompt({ postfix = " --glob !'**/tests/**'" }),
                    --             -- freeze the current list and start a fuzzy search in the frozen list
                    --         },
                    --     },
                    --     -- ... also accepts theme settings, for example:
                    --     -- theme = "dropdown", -- use dropdown theme
                    --     -- theme = { }, -- use own theme spec
                    --     -- layout_config = { mirror=true }, -- mirror preview pane
                    -- }
                },
            })

            require("telescope").load_extension("file_browser")

            -- local find_files_hijack_netrw = vim.api.nvim_create_augroup("find_files_hijack_netrw", { clear = true })
            -- clear FileExplorer appropriately to prevent netrw from launching on folders
            -- netrw may or may not be loaded before telescope-find-files
            -- conceptual credits to nvim-tree and telescope-file-browser
            -- vim.api.nvim_create_autocmd("VimEnter", {
            --     pattern = "*",
            --     once = true,
            --     callback = function()
            --         pcall(vim.api.nvim_clear_autocmds, { group = "FileExplorer" })
            --     end,
            -- })
            -- vim.api.nvim_create_autocmd("BufEnter", {
            --     group = find_files_hijack_netrw,
            --     pattern = "*",
            --     callback = function()
            --         vim.schedule(function()
            --             -- Early return if netrw or not a directory
            --             if vim.bo[0].filetype == "netrw" or vim.fn.isdirectory(vim.fn.expand("%:p")) == 0 then
            --                 return
            --             end
            --
            --             vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")
            --
            --             require("telescope.builtin").find_files({
            --                 cwd = vim.fn.expand("%:p:h"),
            --             })
            --         end)
            --     end,
            -- })
            -- require("telescope").load_extension("live_grep_args")
            vim.keymap.set("n", "<leader>en", function()
                require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })
            end)

            vim.keymap.set("n", "<leader>fk", function()
                require('telescope.builtin').keymaps()
            end)

            vim.keymap.set("n", "<leader>ep", function()
                require('telescope.builtin').find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy') })
            end)

            require('custom.telescope.multigrep').setup()
        end
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },
}
