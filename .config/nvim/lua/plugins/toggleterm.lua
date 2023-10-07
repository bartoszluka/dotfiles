return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            open_mapping = "<C-t>",
            shell = "fish",
            direction = "float",
        })
    end,
    keys = { { "<C-t>" } },
}
