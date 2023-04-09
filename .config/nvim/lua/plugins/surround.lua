return {
    "kylechui/nvim-surround",
    version = "*",
    opts = {
        keymaps = {
            visual = "s",
        },
        highlight = { duration = 200 },
        aliases = {
            ["q"] = { '"', "'", "`" },
            ["s"] = {
                -- add matching pair so that neovim does not freak out
                "{", -- }
                "[", -- ]
                "(", -- )
                "<", -- >
                '"',
                "'",
                "`",
            },
            ["b"] = ")",
            ["r"] = "]",
            ["B"] = "}",
        },
        surrounds = {
            -- TODO: do this just for lua
            ["f"] = {
                add = function()
                    return { { "function() " }, { " end" } }
                end,
            },
            q = { add = { '"', '"' } },
        },
        indent_lines = false,
        move_cursor = false,
    },
}
