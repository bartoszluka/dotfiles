return {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    enabled = false,
    opts = {
        -- indent = { char = "|" },
        whitespace = {
            highlight = {
                "Whitespace",
                "NonText",
                remove_blankline_trail = true,
            },
        },
        scope = { enabled = true },
    },

    -- config = function(opts)
    --     vim.opt.list = true
    --     vim.opt.listchars:append("space:·")
    --     vim.opt.listchars:append("tab:·→")
    --
    --     require("ibl").setup(opts)
    --     require("ibl").setup({
    --         show_first_indent_level = true,
    --         show_trailing_blankline_indent = false,
    --         space_char_blankline = " ",
    --     })
    -- end,
}
