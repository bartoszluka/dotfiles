return {
    "nvim-neotest/neotest",
    dependencies = {
        "mrcjkb/neotest-haskell",
        "nvim-lua/plenary.nvim",
        "nvim-neotest/neotest-plenary",
        "nvim-treesitter/nvim-treesitter",
        "rouge8/neotest-rust",
        "antoinemadec/FixCursorHold.nvim",
    },
    cmd = "NeotestRun",
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-haskell")({
                    build_tools = { "stack" },
                    frameworks = { "hspec" },
                }),
                require("neotest-rust"),
            },
            require("neotest-plenary"),
        })
        vim.api.nvim_create_user_command("NeotestRun", require("neotest").run.run, {})
    end,
}
