return {
    "MrcJkb/haskell-tools.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim", -- optional
        "hrsh7th/cmp-nvim-lsp",
    },
    ft = { "haskell", "lhaskell", "cabal" },
    config = function()
        local keymap = function(lhs, rhs, opts)
            local extended_opts = vim.tbl_extend("keep", { noremap = true, silent = true }, opts)
            vim.keymap.set("n", lhs, rhs, extended_opts)
        end

        local ht = require("haskell-tools")
        ht.setup({
            hls = {
                -- See nvim-lspconfig's  suggested configuration for keymaps, etc.
                on_attach = function(_, bufnr)
                    -- NOTE: Remember that lua is a real programming language, and as such it is possible
                    -- to define small helper and utility functions so you don't have to repeat yourself
                    -- many times.
                    --
                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local nmap = function(keys, func, desc)
                        if desc then
                            desc = "LSP: " .. desc
                        end

                        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
                    end
                    nmap("<leader>r", vim.lsp.buf.rename, "[R]ename")
                    nmap("<leader>a", vim.lsp.buf.code_action, "Code [A]ction")

                    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
                    nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
                    nmap("gr", require("telescope.builtin").lsp_references)
                    nmap("<leader>ls", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                    nmap(
                        "<leader>lS",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[W]orkspace [S]ymbols"
                    )

                    -- this might be wrong
                    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
                        if vim.lsp.buf.format then
                            vim.lsp.buf.format()
                        elseif vim.lsp.buf.formatting then
                            vim.lsp.buf.formatting()
                        end
                    end, { desc = "Format current buffer with LSP" })
                    nmap("<leader>f", "<cmd>:Format<CR>", "Format file")
                    -- See `:help K` for why this keymap
                    -- nmap("K", vim.lsp.buf.hover, "Hover Documentation")
                    nmap("gh", vim.diagnostic.open_float, "Open diagnostic")

                    -- Lesser used LSP functionality
                    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
                    -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
                    -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
                    -- nmap('<leader>wl', function()
                    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    -- end, '[W]orkspace [L]ist Folders')

                    -- haskell-language-server relies heavily on codeLenses,
                    -- so auto-refresh (see advanced configuration) is enabled by default
                    keymap("<leader>ha", vim.lsp.codelens.run, { buffer = bufnr, desc = "code lens" })
                    keymap("<leader>hs", ht.hoogle.hoogle_signature, { buffer = bufnr, desc = "hoogle signature" })
                    -- default_on_attach(client, bufnr)  -- if defined, see nvim-lspconfig
                end,
            },
            capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        })

        local telescope = require("telescope")
        telescope.load_extension("ht")
        telescope.load_extension("hoogle")
        -- Suggested keymaps that do not depend on haskell-language-server
        -- Toggle a GHCi repl for the current package
        keymap("<leader>hr", ht.repl.toggle, { desc = "toggle repl (package)" })
        -- Toggle a GHCi repl for the current buffer
        keymap("<leader>ht", "<cmd>Telescope ht hoogle_signature<CR>", { desc = "hoogle signature" })
        keymap("<leader>ht", "<cmd>Telescope hoogle<CR>", { desc = "hoogle" })
        keymap("<leader>hq", ht.repl.quit, { desc = "quit repl" })
    end,
}
