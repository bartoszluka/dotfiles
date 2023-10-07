return {
    "echasnovski/mini.comment",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    version = false,
    keys = {
        { "gc",  mode = { "n", "v" } },
        { "dgc", mode = "n" },
    },
    config = function()
        local comment = require("mini.comment")
        comment.setup({
            options = {
                ignore_blank_lines = false,
            },
        })

        local function is_nil_or_whitespace(s)
            return s == nil or vim.trim(s) == ""
        end
        local function move_and_insert(row, col, after)
            vim.api.nvim_win_set_cursor(0, { row, col })
            if is_nil_or_whitespace(after) then
                vim.cmd("startinsert!")
            else
                vim.cmd("startinsert")
            end
        end

        local function get_pure_commentstring()
            local raw_commentstring = comment.get_commentstring(vim.api.nvim_win_get_cursor(0))
            local commentstring = vim.split(raw_commentstring, "%s", { plain = true, trimempty = true })
            local commentstring_start = commentstring[1] and vim.trim(commentstring[1])
            local commentstring_end = commentstring[2] and vim.trim(commentstring[2])
            return { commentstring_start, commentstring_end }
        end

        local function pad_or_default(s)
            if s == nil then
                return ""
            else
                return " " .. s
            end
        end
        local function get_indented_location(line_number, pattern)
            vim.api.nvim_win_set_cursor(0, { line_number, 0 })
            vim.cmd("normal! ==")
            local line = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]
            local start = string.find(line, pattern, 0, true)
            return start - 1 + #pattern
        end

        local function insert_comment_on_line_relative(line_number, start_string)
            local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

            local srow = row + line_number
            local cs_start, cs_end = unpack(get_pure_commentstring())
            local before = cs_start .. pad_or_default(start_string) .. " "
            local after = pad_or_default(cs_end)

            vim.api.nvim_buf_set_lines(0, srow, srow, false, { before .. after })
            local location = get_indented_location(srow + 1, before)
            move_and_insert(srow + 1, location, after)
        end

        local function insert_comment_at_the_end()
            local srow, _ = unpack(vim.api.nvim_win_get_cursor(0))

            local cs_start, cs_end = unpack(get_pure_commentstring())
            local before = cs_start .. " "
            local after = pad_or_default(cs_end)

            local line = vim.api.nvim_get_current_line()

            local end_col
            if line == "" then
                -- If line is empty, start comment at the correct indentation level
                vim.api.nvim_set_current_line(before .. after)
                vim.api.nvim_command("normal! ==")
                end_col = #vim.api.nvim_get_current_line() - #after
            else
                -- NOTE:
                -- 1. Python is the only language that recommends 2 spaces between the statement and the comment
                -- 2. Other than that, I am assuming that the users wants a space b/w the end of line and start of the comment
                local space = vim.bo.filetype == "python" and "  " or " "
                local line_with_comment = line .. space .. before .. after
                vim.api.nvim_set_current_line(line_with_comment)
                end_col = #line_with_comment - #after
            end
            move_and_insert(srow, end_col, after)
        end

        nx.map({
            {
                "gco",
                function()
                    insert_comment_on_line_relative(0)
                end,
                desc = "insert comment below",
            },
            {
                "gcO",
                function()
                    insert_comment_on_line_relative(-1)
                end,
                desc = "insert comment above",
            },
            {
                "gct",
                function()
                    insert_comment_on_line_relative(-1, "TODO:")
                end,
                desc = "insert a TODO comment above",
            },
            {
                "gcA",
                insert_comment_at_the_end,
                desc = "insert comment above",
            },
        })
    end,
}
