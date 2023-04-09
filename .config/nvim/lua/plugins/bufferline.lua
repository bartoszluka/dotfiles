return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "gbprod/nord.nvim" },
    enabled = false,
    version = "v3.*",
    config = function()
        require("bufferline").setup({
            options = {
                separator_style = "thin",
                diagnostics = "nvim_lsp",
                diagnostics_update_in_insert = true,
                show_buffer_close_icons = false,
                show_close_icon = false,
                always_show_bufferline = false,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "left",
                        highlight = "Directory",
                        separator = false,
                    },
                    {
                        filetype = "no-neck-pain",
                        -- text = "no-neck-pain",
                        text_align = "center",
                        -- highlight = "Directory",
                        separator = true,
                    },
                },
                hover = {
                    enabled = false,
                },
                custom_filter = function(buf, buf_nums)
                    local hidden_filetypes = { "fugitive", "gitcommit", "checkhealth" }
                    return not vim.tbl_contains(hidden_filetypes, vim.bo[buf].filetype)
                end,
            },
            -- highlights = {
            --     fill = {
            --         bg = {
            --             attribute = "fg",
            --             highlight = "Background",
            --         },
            --     },
            -- },
            -- highlights = require("nord.plugins.bufferline").akinsho(),
        })
    end,
    event = { "BufReadPost", "BufNewFile" },
    keys = {
        { "<leader>bn", "<cmd>BufferLineCycleNext<cr>" },
        { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>" },
        { "<leader>bj", "<cmd>BufferLinePick<cr>" },
    },
}
