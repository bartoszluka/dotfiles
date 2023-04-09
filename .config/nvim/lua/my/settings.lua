local signs = { Error = " ", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

nx.set({
    -- General
    clipboard = "unnamedplus",                        -- use system clipboard
    mouse = "a",                                      -- allow mouse in all modes
    showmode = false,                                 -- print vim mode on enter
    termguicolors = true,                             -- set term gui colors
    timeoutlen = 350,                                 -- time to wait for a mapped sequence to complete
    fillchars__append = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:›, vert:▏]],
    list = true,                                      -- Show some invisible characters
    listchars__append = [[space:·, trail:·, tab:·→]], -- Auxiliary files
    undofile = true,                                  -- enable persistent undo
    backup = false,                                   -- create a backup file
    swapfile = false,                                 -- create a swap file
    -- Command line
    -- cmdheight = 1,
    -- Completion menu
    pumheight = 14,          -- completion popup menu height
    shortmess__append = "c", -- don't give completion-menu messages
    -- Gutter
    number = true,           -- show line numbers
    numberwidth = 3,         -- number column width - default "4"
    relativenumber = true,   -- set relative line numbers
    signcolumn = "yes:2",    -- use fixed width signcolumn - prevents text shift when adding signs
    -- Search
    hlsearch = false,        -- highlight matches in previous search pattern
    ignorecase = true,       -- ignore case in search patterns
    smartcase = true,        -- use smart case - ignore case UNLESS /C or capital in search
    -- ...
    wrap = false,            -- wrapping of text
    breakindent = true,
    updatetime = 250,        -- decrease update time
    -- folds
    foldmethod = "expr",
    foldexpr = "nvim_treesitter#foldexpr()",
    hidden = true,                                 -- Enable background buffers
    joinspaces = false,                            -- No double spaces with join
    scrolloff = 4,                                 -- Lines of context
    shiftwidth = 4,                                -- Size of an indent
    sidescrolloff = 8,                             -- Columns of context
    splitbelow = true,                             -- Put new windows below current
    splitright = true,                             -- Put new windows right of current
    expandtab = true,                              -- Use spaces instead of tabs
    completeopt = "menu,menuone,noinsert,preview", -- Set completeopt to have a better completion experience
}, vim.opt)

nx.set({
    signcolumn = "yes",
    cursorline = true,
    foldlevel = 999, --disable folds on start
}, vim.wo)

nx.set({
    guifont = "FiraCode Nerd Font Mono:h9",
    guicursor = "n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20",
    showmode = false,
}, vim.go)
