return {
    "stevearc/dressing.nvim",
    config = function()
        require("dressing").setup({
            select = {
                get_config = function(opts)
                    if opts.kind == "codeaction" then
                        return {
                            backend = "nui",
                            nui = {
                                -- relative = "cursor",
                                -- relative = "editor",
                                border = {
                                    style = "rounded",
                                },
                                max_width = 40,
                            },
                        }
                    end
                end,
            },
        })
    end,
}
