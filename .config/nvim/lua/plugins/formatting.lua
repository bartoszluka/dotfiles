return {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({
                    async = true,
                    lsp_fallback = true,
                })
            end,
            desc = "Format file",
        },
    },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                python = { "isort", "black" },
                -- Use a sub-list to run only the first available formatter
                javascript = { { "prettierd", "prettier" } },
                kotlin = { "ktfmt" },
                fish = { "fish_indent" },
                xml = { "my_xmlformat" },
                sh = { "shfmt" },
                c = { "clang_format" },
                cs = { "csharpier" },
                fsharp = { "fantomas" },
            },

            formatters = {
                fantomas = {
                    command = "fantomas",
                    args = { "$FILENAME" },
                    stdin = false,
                },
                my_xmlformat = {
                    command = "xmlformat",
                    args = {
                        "--selfclose",
                        "--indent",
                        "4",
                        "-",
                    },
                },
                ktfmt = {
                    command = "java",
                    stdin = false,
                    args = {
                        "-jar",
                        "/home/bartek/repos/ktfmt/ktfmt-0.46-jar-with-dependencies.jar",
                        "--dropbox-style",
                        "$FILENAME",
                    },
                },
                csharpier = {
                    command = "dotnet",
                    args = { "csharpier" },
                    stdin = true,
                },
            },
        })
    end,
}
