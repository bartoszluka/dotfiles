return {
    {
        event = { "BufReadPre", "BufNewFile" },
        "tamago324/nlsp-settings.nvim", -- A plugin to configure Neovim LSP using json/yaml files
        opts = {
            config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
            local_settings_dir = ".nlsp-settings",
            local_settings_root_markers_fallback = { ".git" },
            append_default_schemas = true,
            loader = "json",
        },
    },
    {
        event = { "BufReadPre", "BufNewFile" },
        "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
        dependencies = { "Decodetalkers/csharpls-extended-lsp.nvim" },
        config = function()
            vim.lsp.set_log_level(vim.lsp.log_levels.ERROR)
            local servers = require("my.lsp").servers
            local on_attach = require("my.lsp").on_attach
            local capabilities = require("my.lsp").capabilities

            for _, lsp in ipairs(servers) do
                require("lspconfig")[lsp].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end

            -- Example custom configuration for lua
            --
            -- Make runtime files discoverable to the server
            local runtime_path = vim.split(package.path, ";", {})
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
            require("lspconfig").csharp_ls.setup({
                -- cmd = {
                --     "/home/bartek/repos/csharp-language-server/src/CSharpLanguageServer/out/CSharpLanguageServer",
                -- },
                on_attach = on_attach,
                capabilities = capabilities,
                root_dir = require("lspconfig.util").root_pattern(
                    -- "*.sln", sln removed because it screws up with one work project
                    -- "*.fsproj",
                    ".git"
                ),
                handlers = {
                    ["textDocument/definition"] = require("csharpls_extended").handler,
                },
                settings = {
                    csharp = {
                        loglevel = "log",
                    },
                },
            })
        end,
    },
    {
        event = { "BufReadPre", "BufNewFile" },
        "williamboman/mason.nvim", -- Manage external editor tooling i.e LSP servers
        config = true,
    },
    {
        event = { "BufReadPre", "BufNewFile" },
        "williamboman/mason-lspconfig.nvim", -- Automatically install language servers to stdpath
        opts = { ensure_installed = require("my.lsp").servers },
    },
}
