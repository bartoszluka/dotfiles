return {
    "shaunsingh/nord.nvim",
    priority = 1000,
    config = function()
        -- Set colorscheme
        vim.g.nord_contrast = true -- Make sidebars and popup menus like nvim-tree and telescope have a different background
        vim.g.nord_borders = true -- Enable the border between verticaly split windows visable
        vim.g.nord_disable_background = false -- Disable the setting of background color so that NeoVim can use your terminal background
        vim.g.nord_cursorline_transparent = false -- Set the cursorline transparent/visible
        vim.g.nord_enable_sidebar_background = false -- Re-enables the background of the sidebar if you disabled the background of everything
        vim.g.nord_italic = false -- enables/disables italics
        vim.g.nord_uniform_diff_background = false -- enables/disables colorful backgrounds when used in diff mode
        vim.g.nord_bold = false -- enables/disables bold
        require("nord").set()
        vim.cmd("highlight link LspCodeLens Comment")
    end,
}
