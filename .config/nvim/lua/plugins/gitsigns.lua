return {
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        -- lazy = false,
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "契" },
                topdelete = { text = "契" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            yadm = { enable = true },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function keymap(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                -- stylua: ignore start
                keymap("n", "]h", gs.next_hunk, "Next Hunk")
                keymap("n", "[h", gs.prev_hunk, "Prev Hunk")
                keymap({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                keymap({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                keymap("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                keymap("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                keymap("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                keymap("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                keymap("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                keymap("n", "<leader>ghd", gs.diffthis, "Diff This")
                keymap("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
                keymap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
            end,
        },
    },
}
