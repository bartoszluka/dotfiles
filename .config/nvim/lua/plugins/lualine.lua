return {
    -- Set lualine as statusline
    -- See `:help lualine.txt`
    "nvim-lualine/lualine.nvim", -- Fancier statusline
    config = {
        options = {
            icons_enabled = false,
            theme = "nord",
            component_separators = "|",
            section_separators = "",
        },
    },
}
