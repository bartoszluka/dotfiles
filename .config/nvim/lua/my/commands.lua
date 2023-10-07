nx.cmd({
    {
        "Reverse",
        function(args)
            if args.line1 == args.line2 then
                return
            end
            local buffer = vim.api.nvim_get_current_buf()
            local start_line, end_line = args.line1, args.line2
            local lines = vim.api.nvim_buf_get_lines(buffer, start_line - 1, end_line, false)
            local reversed_lines = {}

            for i = #lines, 1, -1 do
                table.insert(reversed_lines, lines[i])
            end

            vim.api.nvim_buf_set_lines(buffer, start_line - 1, end_line, false, reversed_lines)
        end,
        range = true,
        desc = "reverse selected lines",
    },
    {
        "CloseAllFloatingWindows",
        function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                local config = vim.api.nvim_win_get_config(win)
                if config.relative ~= "" then
                    vim.api.nvim_win_close(win, false)
                end
            end
        end,
        desc = "close all floating windows",
    },
})
