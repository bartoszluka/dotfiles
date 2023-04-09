return {
    "ggandor/leap.nvim", -- better in-buffer navigation
    config = function()
        require("leap").add_default_mappings()
        vim.keymap.del({ "x", "o" }, "s")
        vim.keymap.set({ "x", "o" }, "z", "<Plug>(leap-forward-to)", { desc = "leap forward to", silent = true })
        vim.keymap.del({ "x", "o" }, "S")
        vim.keymap.set({ "x", "o" }, "Z", "<Plug>(leap-backward-to)", { desc = "leap forward to", silent = true })
    end,
    dependencies = {
        "tpope/vim-repeat", -- repeat last command on plugins
    },
}
