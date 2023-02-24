return {
    {
        "lewis6991/gitsigns.nvim", -- Add git related info in the signs columns and popups
        dependencies = { "nvim-lua/plenary.nvim" },
        -- Gitsigns
        -- See `:help gitsigns.txt`
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects", -- Additional textobjects for treesitter
        },
    }, -- Highlight, edit, and navigate code
    "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
    "tamago324/nlsp-settings.nvim", -- A plugin to configure Neovim LSP using json/yaml files
    "williamboman/mason.nvim", -- Manage external editor tooling i.e LSP servers
    "williamboman/mason-lspconfig.nvim", -- Automatically install language servers to stdpath
    {
        "hrsh7th/nvim-cmp",
        version = false,
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        -- See `:help indent_blankline.txt`
        config = function()
            vim.opt.list = true
            vim.opt.listchars:append("space:·")
            vim.opt.listchars:append("tab:·→")

            require("indent_blankline").setup({
                show_first_indent_level = true,
                show_trailing_blankline_indent = false,
                space_char_blankline = " ",
            })
        end,
    }, -- Add indentation guides even on blank lines
    {
        "nmac427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically (replaces vim-sleuth)
        config = function()
            require("guess-indent").setup({
                auto_cmd = true, -- Set to false to disable automatic execution
                filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
                    "netrw",
                    "tutor",
                },
                buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
                    "help",
                    "nofile",
                    "terminal",
                    "prompt",
                },
            })
        end,
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = vim.fn.executable("make") == 1,
    },
    -- { "mhartington/formatter.nvim" }, -- formatting
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "kyazdani42/nvim-tree.lua",
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
        },
        config = function()
            require("nvim-tree").setup({
                sync_root_with_cwd = true,
                view = {
                    mappings = {
                        list = {
                            -- add multiple normal mode mappings for edit
                            { key = { "<CR>", "o", "l" }, action = "edit", mode = "n" },
                            { key = { "h" }, action = "close_node", mode = "n" },
                        },
                    },
                },
            })
        end,
    },
    { "akinsho/bufferline.nvim", version = "v3.*", dependencies = "nvim-tree/nvim-web-devicons" },
    { "moll/vim-bbye" },
    -- Terminal Toggle
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                open_mapping = "<C-t>",
                shell = "fish",
                direction = "float",
            })
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
                highlight = { duration = 200 },
                aliases = {
                    ["a"] = ">",
                    ["b"] = ")",
                    ["B"] = "}",
                    ["r"] = "}",
                    ["q"] = { '"', "'", "`" },
                    ["s"] = { "{", "[", "(", ">", '"', "'", "`" },
                    -- ["a"] = "<",
                    -- ["b"] = "(",
                    -- ["B"] = "{",
                    -- ["r"] = "[",
                    -- ["q"] = { '"', "'", "`" },
                    -- ["s"] = { "{", "[", "(", "<", '"', "'", "`" },
                },
            })
        end,
        -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
        -- setup = function()
        --  vim.o.timeoutlen = 500
        -- end
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({ "css", "scss", "html", "javascript", "haskell", "config", "conf" }, {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            })
        end,
    },
    {
        "loqusion/true-zen.nvim",
        opts = {
            modes = { -- configurations per mode
                ataraxis = {
                    shade = "dark", -- if `dark` then dim the padding windows, otherwise when it's `light` it'll brighten said windows
                    backdrop = 0, -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
                    minimum_writing_area = { -- minimum size of main window
                        width = 100,
                        height = 44,
                    },
                    quit_untoggles = false, -- type :q or :qa to quit Ataraxis mode
                    padding = {
                        right = 40,
                        left = 40,
                        top = 0,
                        bottom = 0,
                    },
                    callbacks = {
                        open_post = function()
                            vim.wo.number = true
                            vim.o.relativenumber = true
                            local lualine = require("lualine")
                            lualine.hide({
                                place = { "statusline", "tabline", "winbar" }, -- The segment this change applies to.
                                unhide = true,
                            })
                        end,
                    },
                },
            },
            integrations = {
                tmux = false, -- hide tmux status bar in (minimalist, ataraxis)
                kitty = { -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
                    enabled = false,
                    font = "+3",
                },
                twilight = false, -- enable twilight (ataraxis)
            },
        },
    },

    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        --                  require("telescope.themes").get_dropdown {
                        -- even more opts
                        --                 }

                        -- pseudo code / specification for writing custom displays, like the one
                        -- for "codeactions"
                        -- specific_opts = {
                        --   [kind] = {
                        --     make_indexed = function(items) -> indexed_items, width,
                        --     make_displayer = function(widths) -> displayer
                        --     make_display = function(displayer) -> function(e)
                        --     make_ordinal = function(e) -> string
                        --   },
                        --   -- for example to disable the custom builtin "codeactions" display
                        --      do the following
                        --   codeactions = false,
                        -- }
                    },
                },
            })
        end,
    },
    "wakatime/vim-wakatime",
    "folke/neodev.nvim",
    "MunifTanjim/nui.nvim",
    {
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup({
                select = {
                    get_config = function(opts)
                        if opts.kind == "codeaction" then
                            return {
                                backend = "nui",
                                nui = {
                                    -- relative = "cursor",
                                    -- relative = "editor",
                                    border = {
                                        style = "rounded",
                                    },
                                    max_width = 40,
                                },
                            }
                        end
                    end,
                },
            })
        end,
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },
    { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
    {
        "RRethy/vim-illuminate",
        config = function()
            require("illuminate").configure({
                -- modes_denylist = { "v", "o", "nov" },
                modes_allowlist = { "n" },
                filetypes_denylist = {
                    "dirvish",
                    "fugitive",
                    "alpha",
                },
            })
            vim.keymap.set("n", ",I", require("illuminate").toggle, { desc = "Toggle 'illuminate'" })
        end,
    },
    "lervag/vimtex",
    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end,
    },
    {
        "ggandor/leap.nvim", -- better in-buffer navigation
        config = function()
            require("leap").add_default_mappings()
            vim.keymap.del({ "x", "o" }, "s")
            vim.keymap.set({ "x", "o" }, "z", "<Plug>(leap-forward-to)", { desc = "leap forward to", silent = true })
            vim.keymap.del({ "x", "o" }, "S")
            vim.keymap.set({ "x", "o" }, "Z", "<Plug>(leap-backward-to)", { desc = "leap forward to", silent = true })
        end,
        dependencies = {
            "tpope/vim-repeat", -- repeat last command on plugins
        },
    },
    {
        "ggandor/flit.nvim",
        dependencies = {
            "ggandor/leap.nvim", -- better in-buffer navigation
        },
        config = function()
            require("flit").setup()
        end,
    }, -- better f/t motions
    "tpope/vim-fugitive", -- Git commands in nvim
    -- "tpope/vim-rhubarb", -- Fugitive-companion to interact with github
    "folke/todo-comments.nvim",
    {
        "echasnovski/mini.ai",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            local ai = require("mini.ai")
            ai.setup({
                custom_textobjects = {
                    -- Disable brackets alias in favor of builtin block textobject
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                    b = false,
                    r = ai.gen_spec.pair("[", "]", { type = "balanced" }),
                    -- Whole buffer
                    e = function()
                        local from = { line = 1, col = 1 }
                        local to = {
                            line = vim.fn.line("$"),
                            col = math.max(vim.fn.getline("$"):len(), 1),
                        }
                        return { from = from, to = to }
                    end,
                },
            })
        end,
    },
    {
        -- No need to copy this inside `setup()`. Will be used automatically.
        "echasnovski/mini.indentscope",
        event = { "BufReadPre", "BufNewFile" },
        config = function(_, opts)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "terminal",
                    "Trouble",
                    "lazy",
                    "mason",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
            require("mini.indentscope").setup({
                draw = {
                    -- Delay (in ms) between event and start of drawing scope indicator
                    delay = 0,

                    -- Animation rule for scope's first drawing. A function which, given
                    -- next and total step numbers, returns wait time (in ms). See
                    -- |MiniIndentscope.gen_animation| for builtin options. To disable
                    -- animation, use `require('mini.indentscope').gen_animation.none()`.
                    animation = require("mini.indentscope").gen_animation.none(), --<function: implements constant 20ms between steps>,
                },
                -- Module mappings. Use `''` (empty string) to disable one.
                mappings = {
                    -- Textobjects
                    object_scope = "ii",
                    object_scope_with_border = "ai",

                    -- Motions (jump to respective border line; if not present - body line)
                    goto_top = "[i",
                    goto_bottom = "]i",
                },
                -- Options which control scope computation
                options = {
                    -- Type of scope's border: which line(s) with smaller indent to
                    -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
                    border = "both",

                    -- Whether to use cursor column when computing reference indent.
                    -- Useful to see incremental scopes with horizontal cursor movements.
                    indent_at_cursor = true,

                    -- Whether to first check input line to be a border of adjacent scope.
                    -- Use it if you want to place cursor on function header to get scope of
                    -- its body.
                    try_as_border = false,
                },
                -- Which character to use for drawing scope indicator
                symbol = "│",
            })
        end,
    },
    {
        "echasnovski/mini.move",
        config = function()
            require("mini.move").setup()
        end,
    },
    {
        "nvim-neorg/neorg",
        ft = "norg",
        config = true,
    },
    {
        "monaqa/dial.nvim",
        keys = {
            "<C-a>",
            "<C-x>",
            { "<C-a>", mode = "v" },
            { "<C-x>", mode = "v" },
            { "g<C-a>", mode = "v" },
            { "g<C-x>", mode = "v" },
        },
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
                -- default augends used when no group name is specified
                default = {
                    augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
                    augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
                    augend.constant.alias.bool, -- boolean value (true <-> false)
                },
            })
            vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
            vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
            vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
            vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
            vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
            vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
        end,
    },
    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader>nd",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "delete all notifications",
            },
            {
                "<leader>nv",
                function()
                    require("telescope").extensions.notify.notify()
                end,
                desc = "view notification history",
            },
        },

        opts = {
            render = "simple",
            stages = "fade",
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
    },
    {
        "j-hui/fidget.nvim",
        config = true,
    },
    {
        "echasnovski/mini.basics",
        config = function()
            require("mini.basics").setup({
                -- Options. Set to `false` to disable.
                options = {
                    -- Basic options ('termguicolors', 'number', 'ignorecase', and many more)
                    basic = true,

                    -- Extra UI features ('winblend', 'cmdheight=0', ...)
                    extra_ui = false,

                    -- Presets for window borders ('single', 'double', ...)
                    win_borders = "default",
                },
                -- Mappings. Set to `false` to disable.
                mappings = {
                    -- Basic mappings (better 'jk', save with Ctrl+S, ...)
                    basic = true,

                    -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
                    -- Supply empty string to not create these mappings.
                    option_toggle_prefix = ",",

                    -- Window navigation with <C-hjkl>, resize with <C-arrow>
                    windows = true,

                    -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
                    move_with_alt = false,
                },
                -- Autocommands. Set to `false` to disable
                autocommands = {
                    -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
                    basic = false,

                    -- Set 'relativenumber' only in linewise and blockwise Visual mode
                    relnum_in_visual_mode = false,
                },
            })
            vim.keymap.del({ "n", "v", "i" }, "<C-s>")
            vim.keymap.del({ "n", "i" }, "<C-z>")
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = true,
        keys = {
            -- Lua
            { "<leader>tt", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true } },
            { "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true } },
            { "<leader>td", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true } },
            { "<leader>tl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true } },
            { "<leader>tq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true } },
            { "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true } },
        },
    },
}
