return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects", -- Additional textobjects for treesitter
        {
            "andymass/vim-matchup",
            config = function()
                -- may set any options here
                vim.g.matchup_matchparen_offscreen = { method = "popup" }
            end,
        },
        "windwp/nvim-ts-autotag",
    },
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
        -- [[ Configure Treesitter ]]
        -- See `:help nvim-treesitter`
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.fsharp = {
            install_info = {
                url = "https://github.com/Nsidorenco/tree-sitter-fsharp",
                branch = "develop",
                files = { "src/scanner.cc", "src/parser.c" },
                generate_requires_npm = true,
                requires_generate_from_grammar = true,
            },
            filetype = "fsharp",
        }
        require("nvim-treesitter.configs").setup({
            -- Add languages to be installed here that you want installed for treesitter
            ensure_installed = {
                "bash",
                "elm",
                "fish",
                "haskell",
                "help",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "rust",
                "typescript",
                "vim",
                "yaml",
            },
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<c-space>",
                    node_incremental = "<c-space>",
                    node_decremental = "<c-backspace>",
                },
            },
            matchup = {
                enable = true,
                disable_virtual_text = true,
                include_match_words = true,
            },
            textobjects = {
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                },
                swap = {
                    enable = false,
                    swap_next = {
                        ["<leader>a"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>A"] = "@parameter.inner",
                    },
                },
            },
            autotag = { enable = true },
        })
    end,
}
