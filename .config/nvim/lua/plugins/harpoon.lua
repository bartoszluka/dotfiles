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
        local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { desc = desc })
        end
        map("<leader>sm", "<cmd>Telescope harpoon marks<CR>", "search marks (harpoon)")
        map("<leader>ja", require("harpoon.mark").add_file, "harpoon: add file")
        map("<leader>ju", require("harpoon.ui").toggle_quick_menu, "harpoon: toggle quick menu")
        map("<c-e>", require("harpoon.ui").toggle_quick_menu, "harpoon: toggle quick menu")
        map("<leader>jf", function()
            require("harpoon.ui").nav_file(1)
        end, "harpoon: go to file 1")
        map("<leader>jd", function()
            require("harpoon.ui").nav_file(2)
        end, "harpoon: go to file 2")
        map("<leader>js", function()
            require("harpoon.ui").nav_file(3)
        end, "harpoon: go to file 3")
        map("<leader>jn", require("harpoon.ui").nav_next, "harpoon: navigate next")
        map("<leader>jp", require("harpoon.ui").nav_prev, "harpoon: navigate prev")
    end,
}
