return {
    'nvim-lualine/lualine.nvim',
    config = function()
        local lualine = require("lualine")
        local navic = require("nvim-navic")
        local ok, yandex_statusline = pcall(require, "yandex.statusline")
        local arc_branch = { function() return "" end }
        if ok then
            arc_branch = {
                function() return yandex_statusline.get_branch() end,
                icon = '',
                cond = yandex_statusline
                    .is_arcadia
            }
        end
        lualine.setup({
            options = { theme = 'tokyonight' },
            winbar = {
                lualine_a = { function()
                    return " "
                end },
                lualine_c = {
                    {
                        function()
                            return navic.get_location()
                        end,
                        cond = function()
                            return navic.is_available()
                        end
                    },
                }
            },
            sections = {
                lualine_b = {
                    'branch',
                    arc_branch,
                    'diff',
                    'diagnostics'
                },
                lualine_c = {
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
            }
        })
    end
}
