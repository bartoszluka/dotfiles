return {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        delay = 200,
        filetypes_denylist = {
            "dirvish",
            "fugitive",
            "alpha",
        },
    },
    config = function(_, opts)
        require("illuminate").configure(opts)

        vim.keymap.set({ "n" }, ",I", require("illuminate").toggle, { desc = "Toggle 'illuminate'" })
    end,
}
