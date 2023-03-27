-- disable netrw at the very start of your init.lua (strongly advised)
-- from: https://github.com/nvim-tree/nvim-tree.lua#setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Basic Keymaps ]]
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.o.termguicolors = true

vim.keymap.set({ "n", "v" }, ";", ":", { silent = false })
vim.keymap.set({ "c" }, "<C-l>", "<Right>", { silent = false })

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

vim.api.nvim_create_user_command("Reverse", function(args)
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
end, { range = true, desc = "reverse selected lines" })

require("lazy").setup("plugins")
vim.notify = require("notify")

local nlspsettings = require("nlspsettings")

nlspsettings.setup({
    config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
    local_settings_dir = ".nlsp-settings",
    local_settings_root_markers_fallback = { ".git" },
    append_default_schemas = true,
    loader = "json",
})

-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
-- require("telescope").load_extension("ui-select")

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
-- vim.wo.wrap = false
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"
vim.wo.cursorline = true

-- Set colorscheme
-- vim.g.nord_contrast = true -- Make sidebars and popup menus like nvim-tree and telescope have a different background
-- vim.g.nord_borders = true -- Enable the border between verticaly split windows visable
-- vim.g.nord_disable_background = false -- Disable the setting of background color so that NeoVim can use your terminal background
-- vim.g.nord_cursorline_transparent = false -- Set the cursorline transparent/visible
-- vim.g.nord_enable_sidebar_background = false -- Re-enables the background of the sidebar if you disabled the background of everything
-- vim.g.nord_italic = false -- enables/disables italics
-- vim.g.nord_uniform_diff_background = false -- enables/disables colorful backgrounds when used in diff mode
-- vim.g.nord_bold = false -- enables/disables bold
-- require("nord").set()

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

vim.keymap.set({ "n", "v", "o" }, "L", "$", { silent = true })
vim.keymap.set({ "n", "v", "o" }, "H", "0", { silent = true })
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local telescope = require("telescope")
telescope.load_extension("projects")
local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

telescope.setup({
    defaults = {
        mappings = {},
    },
})
telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
                ["<C-j>"] = {
                    actions.move_selection_next,
                    type = "action",
                    opts = { nowait = true, silent = true },
                },
                ["<C-k>"] = {
                    actions.move_selection_previous,
                    type = "action",
                    opts = { nowait = true, silent = true },
                },
                ["<c-t>"] = trouble.open_with_trouble,
            },
            n = { ["<c-t>"] = trouble.open_with_trouble },
        },
    },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").oldfiles, { desc = "[S]earch [R]ecent" })

-- find plugin files
vim.keymap.set("n", "<leader>sp", function()
    require("telescope.builtin").find_files({ cwd = "~/.config/nvim/lua/plugins" })
end, { desc = "[S]earch [P]lugins" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
        "bash",
        "fish",
        "haskell",
        "help",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "typescript",
        "vim",
        "yaml",
    },
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            -- TODO: I'm not sure for this one.
            scope_incremental = "<c-s>",
            node_decremental = "<c-backspace>",
        },
    },
    textobjects = {
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        swap = {
            enable = false,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
    },
})

-- Diagnostic keymaps
vim.keymap.set("n", "<C-p>", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "<C-n>", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
-- vim.keymap.set("n", "<leader>", vim.diagnostic.open_float, { desc = "Open diagnostic" })
-- vim.keymap.set("n", "<leader>w", "<cmd>:w<CR>", { desc = "Write file" })
vim.keymap.set("n", "<leader>q", "<cmd>:quit<CR>", { desc = "Quit" })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end
    nmap("<leader>r", vim.lsp.buf.rename, "[R]ename")
    nmap("<leader>a", vim.lsp.buf.code_action, "Code [A]ction")

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("gr", require("telescope.builtin").lsp_references)
    nmap("<leader>ls", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>lS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- this might be wrong
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end, { desc = "Format current buffer with LSP" })
    nmap("<leader>f", "<cmd>:Format<CR>", "Format file")
    -- See `:help K` for why this keymap
    -- nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    -- nmap("gh", vim.lsp.buf.signature_help, "Signature Documentation")
    nmap("gh", vim.diagnostic.open_float, "Open diagnostic")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    -- nmap('<leader>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, '[W]orkspace [L]ist Folders')
end
--

-- nvim-cmp supports additional completion capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Enable the following language servers
local servers = { "rust_analyzer", "pyright", "tsserver", "lua_ls" }

-- Ensure the servers above are installed
require("mason-lspconfig").setup({
    ensure_installed = servers,
})

for _, lsp in ipairs(servers) do
    require("lspconfig")[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

-- require("lspconfig").hls.setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
-- })

-- Example custom configuration for lua
--
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT)
                version = "LuaJIT",
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
        },
    },
})
-- nvim-cmp setup
require("codeium")
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "codeium" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    },
    formatting = {
        format = function(_, item)
            local icons = {
                Array = " ",
                Boolean = " ",
                Class = " ",
                Color = " ",
                Constant = " ",
                Constructor = " ",
                Copilot = " ",
                Codeium = "󰘦 ",
                Enum = " ",
                EnumMember = " ",
                Event = " ",
                Field = " ",
                File = " ",
                Folder = " ",
                Function = " ",
                Interface = " ",
                Key = " ",
                Keyword = " ",
                Method = " ",
                Module = " ",
                Namespace = " ",
                Null = " ",
                Number = " ",
                Object = " ",
                Operator = " ",
                Package = " ",
                Property = " ",
                Reference = " ",
                Snippet = " ",
                String = " ",
                Struct = " ",
                Text = " ",
                TypeParameter = " ",
                Unit = " ",
                Value = " ",
                Variable = " ",
            }
            if icons[item.kind] then
                item.kind = icons[item.kind] .. item.kind
            end
            return item
        end,
    },
    experimental = {
        ghost_text = {
            hl_group = "LspCodeLens",
        },
    },
})

-- MINE
vim.go.guifont = "FiraCode Nerd Font Mono:h9"
vim.go.guicursor = "n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.go.showmode = false
vim.cmd("set foldlevel=999")
vim.diagnostic.config({ severity_sort = true })

-- local fold_group = vim.api.nvim_creatfish_indente_augroup("FoldGroup", { clear = true })
-- vim.api.nvim_create_autocmd(
--  { "BufReadPost", "FileReadPost" },
--  { pattern = "*", command = "normal zR", group = fold_group }
-- )

local git_group = vim.api.nvim_create_augroup("GitOrNotGit", { clear = true })
vim.api.nvim_create_autocmd({ "DirChanged" }, {
    pattern = "*",
    callback = function()
        vim.fn.system({ "git", "status" })
        local finder = function()
            local ok, _ = pcall(require("telescope.builtin").git_files, { show_untracked = true })
            if not ok then
                require("telescope.builtin").find_files()
            end
        end
        vim.keymap.set("n", "<leader>sf", finder, { desc = "[S]earch [F]iles" })
    end,
    group = git_group,
})

-- Utilities for creating configurations

local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")
local methods = require("null-ls.methods")

local mh_style = {
    name = "mh_style",
    meta = {
        url = "https://github.com/florianschanda/miss_hit",
        description = "formatter for matlab",
    },
    method = methods.internal.FORMATTING,
    filetypes = { "matlab" },
    generator_opts = {
        command = "/home/bartek/.local/bin/mh_style",
        args = { "--input-encoding=utf-8", "--fix", "$FILENAME" },
        to_temp_file = true,
    },
    factory = helpers.formatter_factory,
}

local matlab_formatter_py = {
    name = "matlab_formatter_py",
    meta = {
        url = "https://github.com/bartoszluka/matlab-formatter",
        description = "formatter for matlab",
    },
    method = methods.internal.FORMATTING,
    filetypes = { "matlab" },
    generator_opts = {
        command = "python",
        args = { "/home/bartek/repos/matlab-formatter/matlab_formatter.py", "$FILENAME" },
        to_stdin = true,
        to_temp_file = true,
    },
    factory = helpers.formatter_factory,
}

null_ls.register({
    helpers.make_builtin(matlab_formatter_py),
    helpers.make_builtin(mh_style),
    null_ls.builtins.formatting.latexindent,
    null_ls.builtins.formatting.black,
    -- null_ls.builtins.formatting.isort,
    null_ls.builtins.diagnostics.fish,
    null_ls.builtins.formatting.fish_indent,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.latexindent,
    -- null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.chktex,
    null_ls.builtins.diagnostics.ltrs,
    null_ls.builtins.diagnostics.proselint,
    -- null_ls.builtins.code_actions.gitsigns,
})

null_ls.setup({
    on_attach = function(_, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
            if vim.lsp.buf.format then
                vim.lsp.buf.format()
            elseif vim.lsp.buf.formatting then
                vim.lsp.buf.formatting()
            end
        end, { desc = "Format current buffer with LSP" })
        vim.keymap.set("n", "<leader>f", "<cmd>:Format<CR>", { buffer = bufnr, desc = "Format file" })
    end,
})

-- require("formatter").setup({
--  -- Enable or disable logging
--  logging = true,
--  -- Set the log level
--  log_level = vim.log.levels.WARN,
--  -- All formatter configurations are opt-in
--  filetype = {
--   -- Formatter configurations for filetype "lua" go here
--   -- and will be executed in order
--   lua = {
--    -- "formatter.filetypes.lua" defines default configurations for the
--    -- "lua" filetype
--    require("formatter.filetypes.lua").stylua,
--   },
--   python = {
--    require("formatter.filetypes.python").isort,
--    require("formatter.filetypes.python").black,
--    function()
--     return {
--      exe = "black",
--      args = { "-l 120", "-q", "-" },
--      stdin = true,
--     }
--    end,
--   },
--   fish = { require("formatter.filetypes.fish").fishindent },
--   -- haskell = { require("formatter.filetypes.haskell") },
--
--   -- Use the special "*" filetype for defining formatter configurations on
--   -- any filetype
--   -- ["*"] = {
--   --   -- "formatter.filetypes.any" defines default configurations for any
--   --   -- filetype
--   --   require("formatter.filetypes.any").remove_trailing_whitespace
--   -- }
--  },
-- })

vim.cmd("set clipboard=unnamedplus")

vim.keymap.set("n", "<leader>u", "g~l", { desc = "Swap case" })
-- vim.keymap.set("n", "<leader>f", function()
--   vim.buf.lsp.format()
-- end, { desc = "Format buffer" })
-- vim.keymap.set("n", "<leader>w", "<cmd>FormatWrite<CR>", { desc = "Format and save file" })
vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { desc = "Write file" })
vim.keymap.set("n", "<leader>W", "<cmd>write<CR>", { desc = "Write file" })

local function cmds(commands)
    local out = ""
    for _, cmd in pairs(commands) do
        out = out .. "<cmd>" .. cmd .. "<CR>"
    end
    return out
end

vim.keymap.set({ "n", "v" }, "<C-j>", "<C-w>j", { desc = "Focus window to the bottom" })
vim.keymap.set({ "n", "v" }, "<C-k>", "<C-w>k", { desc = "Focus window to the top" })
vim.keymap.set({ "n", "v" }, "<C-l>", "<C-w>l", { desc = "Focus window to the right" })
vim.keymap.set({ "n", "v" }, "<C-h>", "<C-w>h", { desc = "Focus window to the left" })

-- vim.keymap.set("n", "<leader>f", "<cmd>Format<CR>", { desc = "Format buffer" })
-- vim.keymap.set("n", "<leader>x", "<cmd>BufferKill<CR>", { desc = "Close Buffer" })
-- vim.keymap.set("n", "<leader>c", "<cmd>TZAtaraxis<CR>", { desc = "Center buffer" })
-- vim.keymap.set("n", "<leader>u", "g~l", { desc = "Swap case" })
--
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.hidden = true -- Enable background buffers
-- vim.opt.ignorecase = true -- Ignore case
vim.opt.joinspaces = false -- No double spaces with join
vim.opt.list = true -- Show some invisible characters
-- vim.opt.number = true -- Show line numbers
-- vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 4 -- Lines of context
-- vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.sidescrolloff = 8 -- Columns of context
-- vim.opt.smartcase = true -- Do not ignore case with capitals
-- vim.opt.smartindent = true -- Insert indents automatically
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
-- vim.opt.tabstop = 2 -- Number of spaces tabs count for
-- vim.opt.termguicolors = true -- True color support
vim.opt.wrap = false -- Disable line wrap
--
-- vim.opt.wildmode = { "list", "longest" } -- Command-line completion mode
-- The line beneath this is called `modeline`. See `:help modeline`
