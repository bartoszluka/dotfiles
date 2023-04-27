-- Diagnostic keymaps
vim.diagnostic.config({ severity_sort = true })
nx.map({
    {
        "[e",
        function()
            vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "prev error",
    },
    {
        "]e",
        function()
            vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "next error",
    },
})
nx.map({
    { "L", "$", { "n", "v", "o" }, silent = true },
    { "H", "0", { "n", "v", "o" }, silent = true },
})

-- Remap for dealing with word wrap
nx.map({
    { "k", "v:count == 0 ? 'gk' : 'k'", expr = true, silent = true },
    { "j", "v:count == 0 ? 'gj' : 'j'", expr = true, silent = true },
})

nx.map({
    { "<leader>q", "<cmd>confirm quit<CR>", desc = "Quit" },
    { "<leader>u", "g~l", desc = "Swap case" },
    { "<leader>w", "<cmd>write<CR>", desc = "Write file" },
    { "<leader>W", "<cmd>write<CR>", desc = "Write file" },
})

local modes = { "n", "v", "t" }
nx.map({
    { "<C-j>", "<C-w>j", modes, desc = "Focus window to the bottom" },
    { "<C-k>", "<C-w>k", modes, desc = "Focus window to the top" },
    { "<C-l>", "<C-w>l", modes, desc = "Focus window to the right" },
    { "<C-h>", "<C-w>h", modes, desc = "Focus window to the left" },
})
nx.map({
    { ";", ":", { "n", "v" }, silent = false }, -- map ';' to start command mode
    { "<C-l>", "<Right>", { "c" }, silent = false },
})
