return {
    "mrjones2014/legendary.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
        { "<leader>E",     "<cmd>LegendaryEvalLine<CR>", desc = "eval current line" },
    },
    cmd = { "Legendary", "LegendaryEvalLine", "LegendaryEvalLines" },
    config = true,
}
