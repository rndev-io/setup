return {
    "mfussenegger/nvim-dap",
    event = "BufReadPre",
    module = { "dap" },
    dependencies = {
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap-python",
        "nvim-telescope/telescope-dap.nvim",
        { "leoluz/nvim-dap-go",                module = "dap-go" },
        { "jbyuki/one-small-step-for-vimkind", module = "osv" },
    },
    config = function()
        require("custom.dap").setup()
    end,
}
