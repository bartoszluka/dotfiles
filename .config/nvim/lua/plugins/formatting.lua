return {
    "stevearc/conform.nvim",
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
    opts = function()
        return {
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                python = { "isort", "black" },
                -- Use a sub-list to run only the first available formatter
                javascript = { { "prettierd", "prettier" } },
                kotlin = { "ktfmt" },
                fish = { "fish_indent" },
                xml = { "xmlformat" },
                sh = { "shfmt" },
                c = { "clang_format" },
                csharp = { "csharpier" },
            },

            formatters = {
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
                    cwd = require("conform.util").root_file({ ".csharpierrc.yaml", "*.sln" }),
                },
            },
        }
    end,
}
