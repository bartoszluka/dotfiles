return {
    "ThePrimeagen/harpoon",
    keys = {
        { "<leader>j", desc = "+harpoon" },
    },
    config = function()
        require("harpoon").setup({
            global_settings = {
                -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
                save_on_toggle = false,
                -- saves the harpoon file upon every change. disabling is unrecommended.
                save_on_change = true,
                -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
                enter_on_sendcmd = false,
                -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
                tmux_autoclose_windows = false,
                -- filetypes that you want to prevent from adding to the harpoon list menu.
                excluded_filetypes = { "harpoon", "help", "NvimTree" },
                -- set marks specific to each git branch inside git repository
                mark_branch = false,
            },
        })
        nx.map({ "<leader>sm", "<cmd>Telescope harpoon marks<CR>", desc = "search marks (harpoon)" })
        nx.map({ "<leader>ja", require("harpoon.mark").add_file, desc = "harpoon: add file" })
        nx.map({ "<leader>ju", require("harpoon.ui").toggle_quick_menu, desc = "harpoon: toggle quick menu" })
        nx.map({ "<leader>j<leader>", require("harpoon.ui").toggle_quick_menu, desc = "harpoon: toggle quick menu" })
        nx.map({
            "<leader>jf",
            function()
                require("harpoon.ui").nav_file(1)
            end,
            desc = "harpoon: go to file 1",
        })
        nx.map({
            "<leader>jd",
            function()
                require("harpoon.ui").nav_file(2)
            end,
            desc = "harpoon: go to file 2",
        })
        nx.map({
            "<leader>js",
            function()
                require("harpoon.ui").nav_file(3)
            end,
            desc = "harpoon: go to file 3",
        })
        nx.map({ "<leader>jn", require("harpoon.ui").nav_next, desc = "harpoon: navigate next" })
        nx.map({ "<leader>jp", require("harpoon.ui").nav_prev, desc = "harpoon: navigate prev" })
    end,
}
