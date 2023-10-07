return {
    "echasnovski/mini.ai",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local ai = require("mini.ai")
        ai.setup({
            custom_textobjects = {
                -- Disable brackets alias in favor of builtin block textobject
                o = ai.gen_spec.treesitter({
                    a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                    i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                }, {}),
                f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                b = false,
                r = ai.gen_spec.pair("[", "]", { type = "balanced" }),
                -- Whole buffer
                e = function()
                    local from = { line = 1, col = 1 }
                    local to = {
                        line = vim.fn.line("$"),
                        col = math.max(vim.fn.getline("$"):len(), 1),
                    }
                    return { from = from, to = to }
                end,
            },
        })
    end,
}
