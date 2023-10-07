return {
    "hrsh7th/nvim-cmp",
    version = false,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            -- build = (not jit.os:find("Windows"))
            --         and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
            --     or nil,
            dependencies = {
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
            opts = {
                history = true,
                delete_check_events = "TextChanged",
            },
        },
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "Dosx001/cmp-commit",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-emoji",
        {
            "jcdickinson/codeium.nvim",
            config = true,
            dependencies = { "nvim-lua/plenary.nvim" },
            build = function()
                local bin_path = vim.fn.stdpath("cache") .. "/codeium/bin"
                local binaries = vim.fs.find(function()
                    return true
                end, { type = "file", limit = math.huge, path = bin_path })
                table.remove(binaries) -- remove last item (= most up to date binary) from list
                for _, binary in pairs(binaries) do
                    os.remove(binary)
                    os.remove(vim.fs.dirname(binary))
                end
            end,
        },
        { "mtoohey31/cmp-fish", ft = "fish" },
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

        cmp.setup({
            method = "getCompletionsCycling",
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            preselect = cmp.PreselectMode.Item,
            mapping = {
                ["<C-n>"] = cmp.mapping(
                    cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    { "i", "c" }
                ),
                ["<C-p>"] = cmp.mapping(
                    cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    { "i", "c" }
                ),
                ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
                ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
                ["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "s", "c" }),
                ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                ["<C-y>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    local has_words_before = function()
                        unpack = unpack or table.unpack
                        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                        return col ~= 0
                            and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
                                == nil
                    end
                    if cmp.visible() and has_words_before() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s", "c" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s", "c" }),
            },
            sources = {
                { name = "nvim_lsp" },
                { name = "nvim_lua" },
                { name = "codeium" },
                { name = "path" },
                { name = "emoji" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "nvim_lsp_signature_help" },
                { name = "fish" },
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
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            -- view = { entries = "native" },
            experimental = {
                ghost_text = {
                    hl_group = "LspCodeLens",
                },
            },
        })

        -- Fix for autopairs with cmp
        -- cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

        -- `/` cmdline setup.
        cmp.setup.cmdline("/", {
            sources = {
                { name = "buffer" },
            },
        })

        -- `:` cmdline setup.
        cmp.setup.cmdline(":", {
            sources = cmp.config.sources({ name = "path" }, {
                {
                    name = "cmdline",
                    option = {
                        ignore_cmds = { "Man", "!" },
                    },
                },
            }),
        })

        cmp.setup.filetype("gitcommit", {
            sources = {
                { name = "commit" },
                { name = "emoji", option = { insert = false } },
            },
        })
    end,
}
