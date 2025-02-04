local M = {}

local utils = require('custom.utils')

function M.setup(_)
    local dap_python = require('dap-python')
    dap_python.resolve_python = utils.python_path
    dap_python.test_runner = 'pytest'
    dap_python.setup('python')
    -- dap_python.setup(utils.python_path(), {
    --     options = {
    --         env = {
    --             DB_USE_ARCADIA_RECIPE = vim.env.DB_USE_ARCADIA_RECIPE,
    --             Y_PYTHON_ENTRY_POINT = vim.env.Y_PYTHON_ENTRY_POINT,
    --             Y_PYTHON_SOURCE_ROOT = vim.env.Y_PYTHON_SOURCE_ROOT,
    --         }
    --     }
    -- })
end

return M
