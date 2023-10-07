return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "tsakirist/telescope-lazy.nvim",
        "nvim-telescope/telescope-fzy-native.nvim",
        "ThePrimeagen/harpoon",
        {
            "prochri/telescope-all-recent.nvim",
            config = true,
            dependencies = { "kkharji/sqlite.lua" },
        },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local trouble = require("trouble.providers.telescope")

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-u>"] = false,
                        ["<C-d>"] = false,
                        ["<C-j>"] = {
                            actions.move_selection_next,
                            type = "action",
                            opts = { nowait = true, silent = true },
                        },
                        ["<C-k>"] = {
                            actions.move_selection_previous,
                            type = "action",
                            opts = { nowait = true, silent = true },
                        },
                        ["<c-t>"] = trouble.open_with_trouble,
                    },
                    n = { ["<c-t>"] = trouble.open_with_trouble },
                },
            },
            extensions = {
                fzy_native = {
                    override_generic_sorter = false,
                    override_file_sorter = true,
                },
                lazy = {
                    -- Optional theme (the extension doesn't set a default theme)
                    -- theme = "nord",
                    -- Whether or not to show the icon in the first column
                    show_icon = true,
                    -- Mappings for the actions
                    mappings = {
                        open_in_browser = "<C-o>",
                        open_in_file_browser = "<M-b>",
                        open_in_find_files = "<C-f>",
                        open_in_live_grep = "<C-g>",
                        open_plugins_picker = "<C-b>", -- Works only after having called first another action
                        open_lazy_root_find_files = "<C-r>f",
                        open_lazy_root_live_grep = "<C-r>g",
                    },
                    -- Other telescope configuration options
                },
            },
        })

        telescope.load_extension("lazy")
        telescope.load_extension("projects")
        telescope.load_extension("fzy_native")
        telescope.load_extension("smart_open")
        telescope.load_extension("harpoon")

        local builtin = require("telescope.builtin")

        nx.map({
            { "<leader>s/", builtin.current_buffer_fuzzy_find, desc = "/ search in current buffer" },
            {
                "<leader>sf",
                function()
                    telescope.extensions.smart_open.smart_open({ cwd_only = true })
                end,
                desc = "search files",
            },
            { "<leader>sh", builtin.help_tags, desc = "search help" },
            { "<leader>sw", builtin.grep_string, desc = "search current word" },
            { "<leader>sg", builtin.live_grep, desc = "search by grep" },
            { "<leader>sd", builtin.diagnostics, desc = "search diagnostics" },
            { "<leader>sr", builtin.oldfiles, desc = "search recent" },
            { "<leader>sl", telescope.extensions.lazy.lazy, desc = "search lazy.nvim" },
            { "<leader><leader>", builtin.commands, desc = "commands" },
            { "<leader>sc", builtin.command_history, desc = "search command history" },
            { "<leader>sk", builtin.keymaps, desc = "search keymaps" },
            { "<leader>ss", builtin.lsp_document_symbols, desc = "search symbols (file)" },
            { "<leader>sS", builtin.lsp_dynamic_workspace_symbols, desc = "search symbols (project)" },
        })
    end,
    keys = { { "<leader>s" } },
}
