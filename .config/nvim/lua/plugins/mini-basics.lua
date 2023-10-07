return {
    "echasnovski/mini.basics",
    version = false,
    config = function()
        local prefix = ","
        require("mini.basics").setup({
            -- Options. Set to `false` to disable.
            options = {
                -- Basic options ('termguicolors', 'number', 'ignorecase', and many more)
                basic = true,

                -- Extra UI features ('winblend', 'cmdheight=0', ...)
                extra_ui = false,

                -- Presets for window borders ('single', 'double', ...)
                win_borders = "default",
            },
            -- Mappings. Set to `false` to disable.
            mappings = {
                -- Basic mappings (better 'jk', save with Ctrl+S, ...)
                basic = true,

                -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
                -- Supply empty string to not create these mappings.
                option_toggle_prefix = prefix,

                -- Window navigation with <C-hjkl>, resize with <C-arrow>
                windows = true,

                -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
                move_with_alt = false,
            },
            -- Autocommands. Set to `false` to disable
            autocommands = {
                -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
                basic = false,

                -- Set 'relativenumber' only in linewise and blockwise Visual mode
                relnum_in_visual_mode = false,
            },
        })
        vim.keymap.del({ "n", "v", "i" }, "<C-s>")
        vim.keymap.del({ "n", "i" }, "<C-z>")
        local toggle_codeium = function()
            local enabled = vim.fn["codeium#Enabled"]()
            vim.g.codeium_enabled = not enabled
        end
        vim.keymap.del({ "n" }, prefix .. "C")
        vim.keymap.set({ "n" }, prefix .. "C", toggle_codeium, { desc = "Toggle 'Codeium'" })
        vim.keymap.set({ "n" }, prefix .. "u", function()
            require("symbol-usage").toggle()
        end, { desc = "Toggle symbol usage" })

        vim.keymap.del({ "n" }, prefix .. "h")
        vim.keymap.set({ "n" }, prefix .. "h", function()
            vim.o.hlsearch = not vim.o.hlsearch
            if vim.o.hlsearch then
                print("  hlsearch")
            else
                print("nohlsearch")
            end
        end, { desc = "Toggle search highlight" })
    end,
}
