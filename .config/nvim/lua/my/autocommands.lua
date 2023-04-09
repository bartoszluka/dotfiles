nx.au({
    "FileType",
    desc = "fix commentstring for c-like languages",
    pattern = { "c", "cpp", "cs", "java" },
    command = "setlocal commentstring=//%s",
}, { create_group = "FixCommentString" })

nx.au({
    "BufEnter",
    desc = "start in insert mode in git commit message buffer",
    pattern = "COMMIT_EDITMSG",
    command = "startinsert",
}, { create_group = "GitCommit" })

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
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "gitcommit",
        "checkhealth",
        "neotest-output",
        "",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        nx.map({ "q", "<cmd>close<cr>", buffer = event.buf, silent = true })
    end,
}, { create_group = "CloseWithQ" })

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

-- this still does not work
-- nx.au({
--     "BufWinEnter",
--     "BufReadPost",
--     --  not sure these 2 are needed
--     "FileReadPost",
--     pattern = "*",
--     command = "normal! zR",
-- }, { create_group = "FoldGroup" })

