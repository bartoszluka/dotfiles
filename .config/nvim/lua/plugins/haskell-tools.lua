return {
    "MrcJkb/haskell-tools.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim", -- optional
        "hrsh7th/cmp-nvim-lsp",
    },
    branch = "1.x.x",
    ft = { "haskell", "lhaskell", "cabal" },
    config = function()
        local ht = require("haskell-tools")
        ht.start_or_attach({
            hls = {
                on_attach = require("my.lsp").on_attach,
                capabilities = require("my.lsp").capabilities,
            },
        })
        -- local telescope = require("telescope")
        -- telescope.load_extension("ht")
        -- telescope.load_extension("hoogle")
        -- nx.map({
        --     -- Toggle a GHCi repl for the current package
        --     { "<leader>hr", ht.repl.toggle, desc = "toggle repl (package)" },
        --     { "<leader>ht", "<cmd>Telescope ht hoogle_signature<CR>", desc = "hoogle signature" },
        --     { "<leader>ht", "<cmd>Telescope hoogle<CR>", desc = "hoogle" },
        --     { "<leader>hq", ht.repl.quit, desc = "quit repl" },
        -- })
    end,
}
