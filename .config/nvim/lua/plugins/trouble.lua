return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("trouble").setup({
            action_keys = {
                jump = {},
                close = { "q", "<ESC>" },
                cancel = {},
                jump_close = { "o", "<CR>" }, -- jump to the diagnostic and close the list
            },
            auto_jump = { "lsp_references", "lsp_definitions" },
        })
        local trouble_open = function()
            local ok, trouble = pcall(require, "trouble")
            if ok then
                vim.defer_fn(function()
                    vim.cmd("cclose")
                    trouble.open("quickfix")
                end, 0)
            end
        end
        local function augroup(name)
            return vim.api.nvim_create_augroup("MyGroup" .. name, { clear = true })
        end

        vim.api.nvim_create_autocmd("BufWinEnter", {
            group = augroup("TroubleAsQuickfix"),
            pattern = "quickfix",
            callback = trouble_open,
            desc = "Toggle Trouble when entering quickfix buffer",
        })
        vim.api.nvim_create_autocmd("VimLeave", {
            pattern = "*",
            group = augroup("CloseTroubleWhenLeaving"),
            desc = "Close Trouble when leaving neovim",
            callback = function()
                local ok, trouble = pcall(require, "trouble")
                if ok then
                    vim.defer_fn(function()
                        vim.cmd("cclose")
                        trouble.open("quickfix")
                    end, 0)
                end
            end,
        })
    end,
    ft = { "qf" },
    event = { "DiagnosticChanged" },
    keys = {
        { "<leader>tt", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true } },
        { "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true } },
        { "<leader>td", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true } },
        { "<leader>tl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true } },
        { "<leader>tq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true } },
        { "gr", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true } },
        { "gd", "<cmd>TroubleToggle lsp_definitions<cr>", { silent = true, noremap = true } },
    },
}
