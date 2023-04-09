return {
    "kyazdani42/nvim-tree.lua",
    -- keys = {
    --     { "<leader>e", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Toggle file explorer" },
    -- },
    enabled = false,
    config = function()
        require("nvim-tree").setup({
            sync_root_with_cwd = true,
            view = {
                mappings = {
                    list = {
                        -- add multiple normal mode mappings for edit
                        { key = { "<CR>", "o", "l" }, action = "edit",       mode = "n" },
                        { key = { "h" },              action = "close_node", mode = "n" },
                    },
                },
            },
        })
    end,
}
