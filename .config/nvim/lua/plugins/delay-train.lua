return {
    -- Delay repeat execution of certain keys
    "ja-ford/delaytrain.nvim",
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        delay_ms = 1000,  -- How long repeated usage of a key should be prevented
        grace_period = 3, -- How many repeated keypresses are allowed
        keys = {
            -- Which keys (in which modes) should be delayed
            ["nv"] = { "h", "j", "k", "l", "w", "b", "e" },
            ["nvi"] = { "<Left>", "<Down>", "<Up>", "<Right>" },
        },
        ignore_filetypes = {
            "help",
            "NvimTr*",
            "fugitive",
        }, -- Example: set to {"help", "NvimTr*"} to
        -- disable the plugin for help and NvimTree
    },
}
