return {
    -- Set lualine as statusline
    -- See `:help lualine.txt`
    "nvim-lualine/lualine.nvim", -- Fancier statusline
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            icons_enabled = true,
            theme = "auto",
            component_separators = "|",
            section_separators = "",
        },
    },
}
