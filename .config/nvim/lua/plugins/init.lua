return {
    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    "wakatime/vim-wakatime",
    "folke/neodev.nvim",
    "MunifTanjim/nui.nvim",
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },
    {
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle",
    },
    {
        "folke/which-key.nvim",
        config = true,
    },
    {
        "echasnovski/mini.move",
        config = function()
            require("mini.move").setup({
                options = { reindent_linewise = false },
            })
        end,
    },
    {
        "nvim-neorg/neorg",
        ft = "norg",
        config = true,
    },
    {
        "j-hui/fidget.nvim",
        config = true,
        tag = "legacy",
    },
    {
        "numtostr/BufOnly.nvim",
        keys = { { "<leader>bo", "<cmd>BufOnly<CR>", desc = "remove all buffers but this one" } },
        cmd = "BufOnly",
    },
    { "mong8se/actually.nvim" },
}
