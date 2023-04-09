return {
    "rcarriga/nvim-notify",
    priority = 100,
    keys = {
        {
            "<leader>nd",
            function()
                require("notify").dismiss({ silent = true, pending = true })
            end,
            desc = "delete all notifications",
        },
        {
            "<leader>nv",
            function()
                require("telescope").extensions.notify.notify()
            end,
            desc = "view notification history",
        },
    },
    config = function()
        require("notify").setup({
            render = "simple",
            stages = "fade",
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        })
        vim.notify = require("notify")
    end,
}
