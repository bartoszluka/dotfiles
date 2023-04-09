return {
    {
        "tenxsoydev/nx.nvim", -- better keymaps
        priority = 1001,
        config = function()
            _G.nx = require("nx")
        end,
    },
}
