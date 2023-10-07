nx.au({
    "FileType",
    desc = "fix commentstring for c-like languages",
    pattern = { "c", "cpp", "cs", "java", "fsharp" },
    command = "setlocal commentstring=//%s",
}, { create_group = "FixCommentString" })

nx.au({
    { "BufRead", "BufNewFile" },
    desc = "disable extending comments with 'o'",
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove("o")
    end,
}, { create_group = "DisableExtendingComments" })

nx.au({
    { "BufRead", "BufNewFile" },
    desc = "fix filetype for .fsproj and .csproj files",
    pattern = "*.[cf]sproj",
    command = "set ft=xml",
}, { create_group = "SetCsprojAsXml" })

nx.au({
    "BufEnter",
    desc = "start in insert mode in git commit message buffer",
    pattern = "*COMMIT_EDITMSG",
    command = "startinsert",
}, { create_group = "GitCommitStartInsert" })

nx.au({
    { "BufRead", "BufNewFile" },
    desc = "set correct filetype and commentstring for .rasi files",
    pattern = "*.rasi",
    callback = function()
        nx.set({
            filetype = "rasi",
            commentstring = "// %s",
        }, vim.bo)
    end,
}, { create_group = "Rasi" })

-- nx.au({
--     { "BufRead", "BufNewFile" },
--     desc = "set correct filetype F# files",
--     pattern = { "*.fs", "*.fsx", "*.fsi" },
--     command = "set filetype=fsharp",
-- }, { create_group = "fsharp" })

-- nx.au({
--     "BufEnter",
--     desc = "set correct filetype and commentstring for polybar conf files",
--     pattern = "do",
--     callback = function()
--         nx.set({
--             filetype = "dosini",
--             commentstring = "# %s",
--         }, vim.bo)
--     end,
-- }, { create_group = "GitCommit" })

nx.au({
    "FileType",
    desc = "set filetype for llvm",
    pattern = "lifelines",
    command = "set filetype=llvm",
}, { create_group = "LLVM" })

-- Check if we need to reload the file when it changed
nx.au({
    "FocusGained",
    "TermClose",
    "TermLeave",
    command = "checktime",
}, { create_group = "CheckIfEditedOutside" })

-- resize splits if window got resized
nx.au({ "VimResized", command = "tabdo wincmd =" }, { create_group = "ResizeSplits" })

-- close some filetypes with <q>
nx.au({
    "FileType",
    pattern = {
        "",
        "PlenaryTestPopup",
        "checkhealth",
        "help",
        "httpResult",
        "lspinfo",
        "man",
        "neotest-output",
        "neotest-output-panel",
        "notify",
        "qf",
        "query",
        "spectre_panel",
        "startuptime",
        "tsplayground",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        nx.map({ "q", "<cmd>close!<cr>", buffer = event.buf, silent = true })
    end,
}, { create_group = "CloseWithQ" })

-- close some filetypes with <q>
nx.au({
    "FileType",
    pattern = { "gitcommit", "help", "starter" },
    callback = function(event)
        nx.map({ "q", "<cmd>quit<cr>", buffer = event.buf, silent = true })
    end,
}, { create_group = "QuitWithQ" })

-- wrap and check for spell in text filetypes
nx.au({
    {
        "FileType",
        pattern = "gitcommit",
        callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
        end,
    },
}, { create_group = "GitCommitGroup" })

nx.au({
    {
        "BufReadPost",
        callback = function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local line_count = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= line_count then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
            vim.cmd("normal! zz")
        end,
    },
})

nx.au({
    "TextYankPost",
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 100 })
    end,
}, { create_group = "HighlightYank" })

nx.au({
    "BufWinEnter",
    "BufReadPost",
    --  not sure these 2 are needed
    -- "FileReadPost",
    pattern = "*",
    -- manually update folds and open all folds
    callback = function()
        vim.cmd("normal! zxzR")
        vim.opt.foldlevel = 99
    end,
}, { create_group = "UpdateFolds" })
