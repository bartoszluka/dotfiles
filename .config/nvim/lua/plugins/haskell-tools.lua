return {
    "MrcJkb/haskell-tools.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
        local ht = require("haskell-tools")
        local def_opts = { noremap = true, silent = true }
        ht.setup({
            hls = {
                -- See nvim-lspconfig's  suggested configuration for keymaps, etc.
                on_attach = function(client, bufnr)
                    local opts = vim.tbl_extend("keep", def_opts, { buffer = bufnr })
                    -- haskell-language-server relies heavily on codeLenses,
                    -- so auto-refresh (see advanced configuration) is enabled by default
                    vim.keymap.set("n", "<leader>a", vim.lsp.codelens.run, opts)
                    vim.keymap.set("n", "<leader>hs", ht.hoogle.hoogle_signature, opts)
                    -- default_on_attach(client, bufnr)  -- if defined, see nvim-lspconfig
                end,
            },
        })
        -- Suggested keymaps that do not depend on haskell-language-server
        -- Toggle a GHCi repl for the current package
        vim.keymap.set("n", "<leader>hr", ht.repl.toggle, def_opts)
        -- Toggle a GHCi repl for the current buffer
        vim.keymap.set("n", "<leader>ht", function()
            ht.repl.toggle(vim.api.nvim_buf_get_name(0))
        end, def_opts)
        vim.keymap.set("n", "<leader>hq", ht.repl.quit, def_opts)
    end,
}
