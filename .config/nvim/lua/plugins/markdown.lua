return {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    cmd = "PeekOpen",
    ft = "markdown",
    config = function()
        require("peek").setup({
            auto_load = true,          -- whether to automatically load preview when entering another markdown buffer
            close_on_bdelete = true,   -- close preview window on buffer delete
            syntax = false,            -- enable syntax highlighting, affects performance
            theme = "dark",            -- 'dark' or 'light'
            update_on_change = false,
            app = "webview",           -- 'webview', 'browser', string or a table of strings explained below
            filetype = { "markdown" }, -- list of filetypes to recognize as markdown relevant if update_on_change is true
            throttle_at = 200000,      -- start throttling when file exceeds this amount of bytes in size
            throttle_time = 1000,      -- minimum amount of time in milliseconds that has to pass before starting new render
        })
        nx.cmd({
            { "PeekOpen",  require("peek").open,  desc = "open markdown preview" },
            { "PeekClose", require("peek").close, desc = "close markdown preview" },
        })
        nx.map({
            { "<LocalLeader>po", require("peek").open,  desc = "open markdown preview" },
            { "<LocalLeader>pc", require("peek").close, desc = "close markdown preview" },
        }, { wk_label = "Peek", ft = "markdown", buffer = 0, silent = true })
    end,
}
