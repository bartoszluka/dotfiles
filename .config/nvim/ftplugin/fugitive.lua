-- Jump to next file, hunk or revision when status screen is opened
vim.api.nvim_command("normal )")

local keymap = function(lhs, rhs)
    vim.keymap.set("n", lhs, rhs, {
        silent = true,
        buffer = true,
        noremap = true,
    })
end
-- Support quitting with q
keymap("q", "<Plug>fugitive:gq")

keymap("J", "<Plug>fugitive:)")
keymap("K", "<Plug>fugitive:(")

-- Use h/l to insert/remove inline diffs of the file under the cursor
keymap ("h", "<Plug>fugitive:<")
keymap ("l", "<Plug>fugitive:>")
