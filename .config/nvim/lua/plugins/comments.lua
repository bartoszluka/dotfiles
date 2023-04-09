return {
    "echasnovski/mini.comment",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    version = false,
    config = function()
        local function move_n_insert(row, col)
            vim.api.nvim_win_set_cursor(0, { row, col })
            vim.api.nvim_feedkeys("a", "ni", true)
        end
        local function ins_on_line(lnum, todo)
            local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

            local srow = row + lnum
            require("ts_context_commentstring.internal").update_commentstring()
            local lcs = vim.split(vim.bo.commentstring, "%s", {plain=true,trimempty=true})[1]

            local todo_string = todo and "TODO: " or ""

            vim.api.nvim_buf_set_lines(0, srow, srow, false, { lcs .. " " .. todo_string })
            vim.api.nvim_win_set_cursor(0, { srow + 1, 0 })
            vim.api.nvim_command("normal! ==")
            move_n_insert(srow + 1, #vim.api.nvim_get_current_line() - 1)
        end

        local function insert_at_the_end()
            local srow, _ = unpack(vim.api.nvim_win_get_cursor(0))

            require("ts_context_commentstring.internal").update_commentstring()
            local lcs = vim.split(vim.bo.commentstring, "%s", {})[1]

            local line = vim.api.nvim_get_current_line()
            local padding = " "

            local ecol
            if line == "" then
                -- If line is empty, start comment at the correct indentation level
                vim.api.nvim_set_current_line(lcs .. padding)
                vim.api.nvim_command("normal! ==")
                ecol = #vim.api.nvim_get_current_line() - 1
            else
                -- NOTE:
                -- 1. Python is the only language that recommends 2 spaces between the statement and the comment
                -- 2. Other than that, I am assuming that the users wants a space b/w the end of line and start of the comment
                local space = vim.bo.filetype == "python" and "  " or " "
                local ll = line .. space .. lcs .. padding
                vim.api.nvim_set_current_line(ll)
                ecol = #ll - 1
            end
            move_n_insert(srow, ecol)
        end

        -- insert comments above/below/at the end of a line
        vim.keymap.set("n", "gco", function()
            ins_on_line(0)
        end, { desc = "insert comment below" })

        vim.keymap.set("n", "gcO", function()
            ins_on_line(-1)
        end, { desc = "insert comment above" })

        vim.keymap.set("n", "gct", function()
            ins_on_line(-1, true)
        end, { desc = "insert comment above starting with TODO:" })

        vim.keymap.set("n", "gcA", insert_at_the_end, { desc = "insert comment above" })

        require("mini.comment").setup({
            options = {
                ignore_blank_lines = false,
            },
            hooks = {
                pre = function()
                    require("ts_context_commentstring.internal").update_commentstring()
                end,
            },
        })
    end,
}
