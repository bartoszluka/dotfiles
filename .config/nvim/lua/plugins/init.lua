return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects", -- Additional textobjects for treesitter
        },
    }, -- Highlight, edit, and navigate code
    "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
    "tamago324/nlsp-settings.nvim", -- A plugin to configure Neovim LSP using json/yaml files
    "williamboman/mason.nvim", -- Manage external editor tooling i.e LSP servers
    "williamboman/mason-lspconfig.nvim", -- Automatically install language servers to stdpath
    {
        "hrsh7th/nvim-cmp",
        version = false,
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = vim.fn.executable("make") == 1,
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    "wakatime/vim-wakatime",
    "folke/neodev.nvim",
    "MunifTanjim/nui.nvim",
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },
    { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
    {
        "folke/which-key.nvim",
        config = true,
    },
    {
        "tpope/vim-fugitive",
        cmd = { "G", "Git", "Gwrite", "Yadm" },
        keys = {
            { "<leader>gg", "<cmd>Git<CR>", desc = "Git fugitive UI" },
            { "<leader>gy", "<cmd>Yadm<CR>", desc = "Yadm" },
            { "<leader>gw", "<cmd>Gwrite<CR>", desc = "Git-add current file" },
        },
        config = function()
            -- for yadm to work
            vim.cmd([[
                function! YadmComplete(A, L, P) abort
                    return fugitive#Complete(a:A, a:L, a:P, {'git_dir': expand("~/.local/share/yadm/repo.git")})
                endfunction
            ]])
            vim.cmd([[
                command! -bang -nargs=? -range=-1 -complete=customlist,YadmComplete Yadm exe
                    \ fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>,
                    \ { 'git_dir': expand("~/.local/share/yadm/repo.git") })
            ]])
        end,
    },
    {
        "echasnovski/mini.move",
        config = function()
            require("mini.move").setup()
        end,
    },
    {
        "nvim-neorg/neorg",
        ft = "norg",
        config = true,
    },
    {
        "j-hui/fidget.nvim",
        config = true,
    },
    "luc-tielen/telescope_hoogle",
}
