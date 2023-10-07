return {
    "jose-elias-alvarez/null-ls.nvim",
    enabled = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")
        local helpers = require("null-ls.helpers")
        local methods = require("null-ls.methods")

        local mh_style = {
            name = "mh_style",
            meta = {
                url = "https://github.com/florianschanda/miss_hit",
                description = "formatter for matlab",
            },
            method = methods.internal.FORMATTING,
            filetypes = { "matlab" },
            generator_opts = {
                command = "/home/bartek/.local/bin/mh_style",
                args = { "--input-encoding=utf-8", "--fix", "$FILENAME" },
                to_temp_file = true,
            },
            factory = helpers.formatter_factory,
        }

        local matlab_formatter_py = {
            name = "matlab_formatter_py",
            meta = {
                url = "https://github.com/bartoszluka/matlab-formatter",
                description = "formatter for matlab",
            },
            method = methods.internal.FORMATTING,
            filetypes = { "matlab" },
            generator_opts = {
                command = "python",
                args = { "/home/bartek/repos/matlab-formatter/matlab_formatter.py", "$FILENAME" },
                to_stdin = true,
                to_temp_file = true,
            },
            factory = helpers.formatter_factory,
        }

        null_ls.register({
            helpers.make_builtin(matlab_formatter_py),
            helpers.make_builtin(mh_style),
            null_ls.builtins.formatting.latexindent,
            null_ls.builtins.formatting.black,
            -- null_ls.builtins.formatting.isort,
            null_ls.builtins.diagnostics.fish,
            null_ls.builtins.formatting.fish_indent,
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.latexindent,
            -- null_ls.builtins.formatting.prettierd,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.diagnostics.chktex,
            -- null_ls.builtins.diagnostics.ltrs,
            -- null_ls.builtins.diagnostics.proselint,
            null_ls.builtins.formatting.clang_format,
            null_ls.builtins.formatting.xmlformat,
            -- null_ls.builtins.formatting.fantomas,
            -- null_ls.builtins.formatting.csharpier,
            null_ls.builtins.formatting.shfmt,
            -- null_ls.builtins.code_actions.gitsigns,
            null_ls.builtins.diagnostics.vale,
        })

        null_ls.setup({
            on_attach = function(_, bufnr)
                vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
                    if vim.lsp.buf.format then
                        vim.lsp.buf.format()
                    elseif vim.lsp.buf.formatting then
                        vim.lsp.buf.formatting()
                    end
                end, { desc = "Format current buffer with LSP" })
                -- vim.keymap.set("n", "<leader>f", "<cmd>:Format<CR>", { buffer = bufnr, desc = "Format file" })

                nx.map({ "gh", vim.diagnostic.open_float, desc = "Open diagnostic" })
            end,
        })
    end,
}
