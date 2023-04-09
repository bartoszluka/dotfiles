return {
    -- No need to copy this inside `setup()`. Will be used automatically.
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    version = false,
    config = function()
        nx.au({
            "FileType",
            pattern = {
                "help",
                "alpha",
                "dashboard",
                "neo-tree",
                "terminal",
                "toggleterm",
                "Trouble",
                "lazy",
                "mason",
                "lspinfo",
            },
            callback = function()
                vim.b.miniindentscope_disable = true
            end,
        }, { create_group = "DisableMiniIndentScope" })
        nx.au({
            "FileType",
            pattern = {
                "haskell",
                "python",
            },
            callback = function()
                vim.b.miniindentscope_config = { options = { border = "top" } }
            end,
        }, { create_group = "ChangeMiniIndentScopeBorder" })
        require("mini.indentscope").setup({
            draw = {
                -- Delay (in ms) between event and start of drawing scope indicator
                delay = 0,
                -- Animation rule for scope's first drawing. A function which, given
                -- next and total step numbers, returns wait time (in ms). See
                -- |MiniIndentscope.gen_animation| for builtin options. To disable
                -- animation, use `require('mini.indentscope').gen_animation.none()`.
                animation = require("mini.indentscope").gen_animation.none(), --<function: implements constant 20ms between steps>,
            },
            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                -- Textobjects
                object_scope = "ii",
                object_scope_with_border = "ai",
                -- Motions (jump to respective border line; if not present - body line)
                goto_top = "[i",
                goto_bottom = "]i",
            },
            -- Options which control scope computation
            options = {
                -- Type of scope's border: which line(s) with smaller indent to
                -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
                border = "both",
                -- Whether to use cursor column when computing reference indent.
                -- Useful to see incremental scopes with horizontal cursor movements.
                indent_at_cursor = true,
                -- Whether to first check input line to be a border of adjacent scope.
                -- Use it if you want to place cursor on function header to get scope of
                -- its body.
                try_as_border = true,
            },
            -- Which character to use for drawing scope indicator
            symbol = "│",
        })
    end,
}
