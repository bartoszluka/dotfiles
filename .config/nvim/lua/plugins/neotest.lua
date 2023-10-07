return {
    "nvim-neotest/neotest",
    dependencies = {
        "mrcjkb/neotest-haskell",
        "nvim-lua/plenary.nvim",
        "nvim-neotest/neotest-plenary",
        "nvim-treesitter/nvim-treesitter",
        "rouge8/neotest-rust",
        "antoinemadec/FixCursorHold.nvim",
        "Issafalcon/neotest-dotnet",
    },
    cmd = {
        "NeotestRunClosest",
        "NeotestRunFile",
    },
    config = function()
        local neotest = require("neotest")
        neotest.setup({
            adapters = {
                require("neotest-haskell")({
                    build_tools = { "stack" },
                    frameworks = { "hspec" },
                }),
                require("neotest-rust"),
                require("neotest-dotnet")({
                    discovery_root = "project",
                }),
            },
            require("neotest-plenary"),
        })
        nx.cmd({
            {
                "NeotestRunClosest",
                neotest.run.run,
                desc = "run test closest to cursor",
            },
            {
                "NeotestRunFile",
                function()
                    neotest.run.run(vim.fn.expand("%"))
                end,
                desc = "run all tests in current file",
            },
        })
    end,
}
