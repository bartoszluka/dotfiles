return {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- See `:help indent_blankline.txt`
    config = function()
        vim.opt.list = true
        vim.opt.listchars:append("space:·")
        vim.opt.listchars:append("tab:·→")

        require("indent_blankline").setup({
            show_first_indent_level = true,
            show_trailing_blankline_indent = false,
            space_char_blankline = " ",
        })
    end,
}
