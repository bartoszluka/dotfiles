return {
    "lewis6991/hover.nvim",
    config = function()
        local hover = require("hover")
        hover.setup({
            init = function()
                -- Require providers
                require("hover.providers.lsp")
                -- require('hover.providers.gh')
                -- require('hover.providers.gh_user')
                -- require('hover.providers.jira')
                -- require('hover.providers.man')
                require("hover.providers.dictionary")
            end,
            preview_opts = {
                border = nil,
            },
            -- Whether the contents of a currently open hover window should be moved
            -- to a :h preview-window when pressing the hover keymap.
            preview_window = false,
            title = true,
        })

        hover.register({
            name = "Diagnostics",
            enabled = function()
                local current_window = 0
                local row, _ = unpack(vim.api.nvim_win_get_cursor(current_window))
                local current_buffer = 0
                local status_ok, diagnostics = pcall(vim.diagnostic.get, current_buffer, { lnum = row - 1 })
                return status_ok and (not vim.tbl_isempty(diagnostics))
            end,
            execute = function(done)
                local current_window = 0
                local row, _ = unpack(vim.api.nvim_win_get_cursor(current_window))
                local current_buffer = 0
                local diagnostics = vim.diagnostic.get(current_buffer, { lnum = row - 1 })
                local messages = {}
                local util = require("vim.lsp.util")
                for key, value in pairs(diagnostics) do
                    messages = util.convert_input_to_markdown_lines(value.message, messages)
                end
                messages = vim.tbl_flatten(messages)

                done({ lines = messages, filetype = "diagnostic" })
            end,
            priority = 999,
        })

        -- Setup keymaps
        vim.keymap.set("n", "K", hover.hover, { desc = "hover.nvim" })
        vim.keymap.set("n", "gK", hover.hover_select, { desc = "hover.nvim (select)" })
    end,
}
