-- disable netrw at the very start of your init.lua (strongly advised)
-- from: https://github.com/nvim-tree/nvim-tree.lua#setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    vim.cmd([[packadd packer.nvim]])
end

require("packer").startup(function(use)
    use("wbthomason/packer.nvim") -- Package manager
    -- I preffer lazygit, maybe in the future I will make a switch
    -- use("tpope/vim-fugitive") -- Git commands in nvim
    -- use("tpope/vim-rhubarb") -- Fugitive-companion to interact with github
    use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } }) -- Add git related info in the signs columns and popups
    use("numToStr/Comment.nvim") -- "gc" to comment visual regions/lines
    use("nvim-treesitter/nvim-treesitter") -- Highlight, edit, and navigate code
    use({ "nvim-treesitter/nvim-treesitter-textobjects", after = { "nvim-treesitter" } }) -- Additional textobjects for treesitter
    use("neovim/nvim-lspconfig") -- Collection of configurations for built-in LSP client
    use("tamago324/nlsp-settings.nvim") -- A plugin to configure Neovim LSP using json/yaml files
    use("williamboman/mason.nvim") -- Manage external editor tooling i.e LSP servers
    use("williamboman/mason-lspconfig.nvim") -- Automatically install language servers to stdpath
    use({ "hrsh7th/nvim-cmp", requires = { "hrsh7th/cmp-nvim-lsp" } }) -- Autocompletion
    use({ "L3MON4D3/LuaSnip", requires = { "saadparwaiz1/cmp_luasnip" } }) -- Snippet Engine and Snippet Expansion
    use("nvim-lualine/lualine.nvim") -- Fancier statusline
    use("lukas-reineke/indent-blankline.nvim") -- Add indentation guides even on blank lines
    -- use("tpope/vim-sleuth") -- Detect tabstop and shiftwidth automatically
    use({
        "nmac427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically (replaces vim-sleuth)
        config = function()
            require("guess-indent").setup({})
        end,
    })

    -- Fuzzy Finder (files, lsp, etc)
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x", requires = { "nvim-lua/plenary.nvim" } })

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable("make") == 1 })

    use({
        "shaunsingh/nord.nvim",
        config = function()
            vim.g.nord_contrast = false --	Make sidebars and popup menus like nvim-tree and telescope have a different background
            vim.g.nord_borders = true --	Enable the border between verticaly split windows visable
            vim.g.nord_disable_background = true --	Disable the setting of background color so that NeoVim can use your terminal background
            vim.g.nord_cursorline_transparent = false --	Set the cursorline transparent/visible
            vim.g.nord_enable_sidebar_background = true --	Re-enables the background of the sidebar if you disabled the background of everything
            vim.g.nord_italic = false --	enables/disables italics
            vim.g.nord_uniform_diff_background = false --	enables/disables colorful backgrounds when used in diff mode
            -- Load the colorscheme
            -- require("nord").set()
        end,
    })
    -- use({ "mhartington/formatter.nvim" }) -- formatting
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    })
    use({
        "kyazdani42/nvim-tree.lua",
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
    })
    use({ "akinsho/bufferline.nvim", tag = "v3.*", requires = "kyazdani42/nvim-web-devicons" })
    use({ "moll/vim-bbye" })
    -- Terminal Toggle
    use({
        "akinsho/toggleterm.nvim",
        tag = "*",
        config = function()
            require("toggleterm").setup({
                open_mapping = "<C-t>",
                shell = "fish",
                direction = "float",
            })
        end,
    })
    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
                highlight = { duration = 200 },
                aliases = {
                    ["a"] = "<",
                    ["b"] = "(",
                    ["B"] = "{",
                    ["r"] = "[",
                    ["q"] = { '"', "'", "`" },
                    ["s"] = { "{", "[", "(", "<", '"', "'", "`" },
                },
            })
        end,
        -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
        -- setup = function()
        --  vim.o.timeoutlen = 500
        -- end
    })
    use({
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
    })
    -- use({
    -- 	"Pocco81/true-zen.nvim",
    -- 	config = function()
    -- 		require("true-zen").setup({
    -- 			modes = { -- configurations per mode
    -- 				ataraxis = {
    -- 					shade = "dark", -- if `dark` then dim the padding windows, otherwise when it's `light` it'll brighten said windows
    -- 					backdrop = 0, -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
    -- 					minimum_writing_area = { -- minimum size of main window
    -- 						width = 100,
    -- 						height = 44,
    -- 					},
    -- 					quit_untoggles = false, -- type :q or :qa to quit Ataraxis mode
    -- 					padding = {
    -- 						right = 40,
    -- 						left = 40,
    -- 						top = 0,
    -- 						bottom = 0,
    -- 					},
    -- 					callbacks = {
    -- 						open_pos = function()
    -- 							vim.wo.number = true
    -- 							vim.o.relativenumber = true
    -- 						end,
    -- 					},
    -- 				},
    -- 			},
    -- 			integrations = {
    -- 				tmux = false, -- hide tmux status bar in (minimalist, ataraxis)
    -- 				kitty = { -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
    -- 					enabled = false,
    -- 					font = "+3",
    -- 				},
    -- 				twilight = false, -- enable twilight (ataraxis)
    -- 				lualine = false, -- hide nvim-lualine (ataraxis)
    -- 			},
    -- 		})
    -- 	end,
    -- })

    use({
        "loqusion/true-zen.nvim",
        config = function()
            require("true-zen").setup({
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
            })
        end,
    })

    use({
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
    })
    use("wakatime/vim-wakatime")
    use("folke/neodev.nvim")
    use("MunifTanjim/nui.nvim")
    use({
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
    })
    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    })
    use("goolord/alpha-nvim")
    use("ahmedkhalf/project.nvim")
    use({
        "MrcJkb/haskell-tools.nvim",
        requires = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim", -- optional
        },
        -- tag = 'x.y.z' -- [^1]
    })
    -- end plugins
    if is_bootstrap then
        require("packer").sync()
    end
end)
require("bartek.alpha")
require("bartek.project")

local nlspsettings = require("nlspsettings")

nlspsettings.setup({
    config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
    local_settings_dir = ".nlsp-settings",
    local_settings_root_markers_fallback = { ".git" },
    append_default_schemas = true,
    loader = "json",
})
require("bartek.haskell-tools")

require("telescope").load_extension("projects")
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
-- require("telescope").load_extension("ui-select")

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
    print("==================================")
    print("    Plugins are being installed")
    print("    Wait until Packer completes,")
    print("       then restart nvim")
    print("==================================")
    return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    command = "source <afile> | PackerCompile",
    group = packer_group,
    pattern = vim.fn.expand("$MYVIMRC"),
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.wrap = false
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
vim.o.termguicolors = true
-- vim.cmd("colorscheme nord")
require("nord").set()

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v", "o" }, "L", "$", { silent = true })
vim.keymap.set({ "n", "v", "o" }, "H", "^", { silent = true })
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

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

-- Set lualine as statusline
-- See `:help lualine.txt`
require("lualine").setup({
    options = {
        icons_enabled = false,
        theme = "nord",
        component_separators = "|",
        section_separators = "",
    },
})

-- Enable Comment.nvim
require("Comment").setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require("indent_blankline").setup({
    char = "|",
    -- char = "┊",
    show_trailing_blankline_indent = false,
})

-- Gitsigns
-- See `:help gitsigns.txt`
require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
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

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { "lua", "python", "rust", "typescript", "haskell" },

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
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
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
            enable = true,
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
vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
-- vim.keymap.set("n", "<leader>w", "<cmd>:w<CR>", { desc = "Write file" })
vim.keymap.set("n", "<leader>q", "<cmd>:q<CR>", { desc = "Quit" })

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

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end, { desc = "Format current buffer with LSP" })
    nmap("<leader>f", "<cmd>:Format<CR>", "Format file")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("gh", vim.lsp.buf.signature_help, "Signature Documentation")

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
local servers = { "clangd", "rust_analyzer", "pyright", "tsserver", "sumneko_lua", "hls" }

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

-- Example custom configuration for lua
--
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").sumneko_lua.setup({
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
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
        },
    },
})

require("lspconfig").pyright.setup({})
-- nvim-cmp setup
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
    sources = { { name = "nvim_lsp" }, { name = "luasnip" } },
})

-- MINE
vim.go.guifont = "FiraCode Nerd Font Mono:h10"
vim.go.guicursor = "n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd("set foldlevel=999")

-- local fold_group = vim.api.nvim_creatfish_indente_augroup("FoldGroup", { clear = true })
-- vim.api.nvim_create_autocmd(
-- 	{ "BufReadPost", "FileReadPost" },
-- 	{ pattern = "*", command = "normal zR", group = fold_group }
-- )
--
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
})

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.latexindent,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.formatting.fish_indent,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.latexindent,
        null_ls.builtins.formatting.prettierd,
    },
})
-- require("formatter").setup({
-- 	-- Enable or disable logging
-- 	logging = true,
-- 	-- Set the log level
-- 	log_level = vim.log.levels.WARN,
-- 	-- All formatter configurations are opt-in
-- 	filetype = {
-- 		-- Formatter configurations for filetype "lua" go here
-- 		-- and will be executed in order
-- 		lua = {
-- 			-- "formatter.filetypes.lua" defines default configurations for the
-- 			-- "lua" filetype
-- 			require("formatter.filetypes.lua").stylua,
-- 		},
-- 		python = {
-- 			require("formatter.filetypes.python").isort,
-- 			require("formatter.filetypes.python").black,
-- 			function()
-- 				return {
-- 					exe = "black",
-- 					args = { "-l 120", "-q", "-" },
-- 					stdin = true,
-- 				}
-- 			end,
-- 		},
-- 		fish = { require("formatter.filetypes.fish").fishindent },
-- 		-- haskell = { require("formatter.filetypes.haskell") },
--
-- 		-- Use the special "*" filetype for defining formatter configurations on
-- 		-- any filetype
-- 		-- ["*"] = {
-- 		--   -- "formatter.filetypes.any" defines default configurations for any
-- 		--   -- filetype
-- 		--   require("formatter.filetypes.any").remove_trailing_whitespace
-- 		-- }
-- 	},
-- })

vim.cmd("set clipboard=unnamedplus")

vim.keymap.set("n", "<leader>u", "v~", { desc = "Swap case" })
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

vim.keymap.set("n", "<leader>c", cmds({ "TZAtaraxis" }), { desc = "Center buffer" })

vim.keymap.set({ "n", "v" }, "<C-j>", "<C-w>j", { desc = "Focus window to the bottom" })
vim.keymap.set({ "n", "v" }, "<C-k>", "<C-w>k", { desc = "Focus window to the top" })
vim.keymap.set({ "n", "v" }, "<C-l>", "<C-w>l", { desc = "Focus window to the right" })
vim.keymap.set({ "n", "v" }, "<C-h>", "<C-w>h", { desc = "Focus window to the left" })

vim.keymap.set({ "o", "x" }, "aq", 'a"', { desc = "around quotes" })
vim.keymap.set({ "o", "x" }, "iq", 'i"', { desc = "inside quotes" })
vim.keymap.set({ "o", "x" }, "ar", "a[", { desc = "around range brackets" })
vim.keymap.set({ "o", "x" }, "ir", "i[", { desc = "inside range brackets" })
vim.keymap.set({ "o", "x" }, "aa", "a<", { desc = "around angle brackets" })
vim.keymap.set({ "o", "x" }, "ia", "i<", { desc = "inside angle brackets" })

-- xnoremap <silent> al :<c-u>normal! $v0<cr>
vim.keymap.set({ "o", "x" }, "ae", ":<C-u>normal ggVG<CR>'", { desc = "around entire file" })
-- vim.keymap.set({ "o", "x" }, "ie", ":<C-u>keepjumps normal ggVG<CR>", { desc = "inside entire file" })

-- vim.keymap.set("n", "<leader>f", "<cmd>Format<CR>", { desc = "Format buffer" })
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
-- vim.keymap.set("n", "<leader>x", "<cmd>BufferKill<CR>", { desc = "Close Buffer" })
-- vim.keymap.set("n", "<leader>c", "<cmd>TZAtaraxis<CR>", { desc = "Center buffer" })
-- vim.keymap.set("n", "<leader>u", "g~l", { desc = "Swap case" })
--
-- vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.hidden = true -- Enable background buffers
-- vim.opt.ignorecase = true -- Ignore case
vim.opt.joinspaces = false -- No double spaces with join
vim.opt.list = true -- Show some invisible characters
-- vim.opt.number = true -- Show line numbers
-- vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 4 -- Lines of context
-- vim.opt.shiftround = true -- Round indent
-- vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.sidescrolloff = 8 -- Columns of context
-- vim.opt.smartcase = true -- Do not ignore case with capitals
-- vim.opt.smartindent = true -- Insert indents automatically
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
-- vim.opt.tabstop = 2 -- Number of spaces tabs count for
-- vim.opt.termguicolors = true -- True color support
-- vim.opt.wrap = false -- Disable line wrap
--
-- vim.opt.wildmode = { "list", "longest" } -- Command-line completion mode
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
