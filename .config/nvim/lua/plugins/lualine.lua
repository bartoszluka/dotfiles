return {
    -- See `:help lualine.txt`
    "nvim-lualine/lualine.nvim",
    enabled = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        { "jcdickinson/wpm.nvim", enabled = false, config = true },
    },
    opts = function()
        -- set up a timer that triggers every minute
        local timer = vim.loop.new_timer()
        if timer then
            timer:start(
                0,
                2 * 60 * 1000,
                vim.schedule_wrap(function()
                    vim.fn.jobstart({ "/home/bartek/.wakatime/wakatime-cli", "--today" }, {
                        stdout_buffered = true,
                        on_stdout = function(_, data)
                            local time = vim.trim(data[1])
                            vim.g.wakatime_today = time
                        end,
                    })
                end)
            )
        end
        nx.au({
            "VimLeave",
            pattern = "*",
            callback = function()
                if timer then
                    timer:stop()
                end
            end,
        }, { create_group = "StopWakaTimeChecking" })

        local function fg(name)
            return function()
                ---@type {foreground?:number}?
                local hl = vim.api.nvim_get_hl_by_name(name, true)
                return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
            end
        end

        return {
            options = {
                theme = "nord",
                -- theme = "auto",
                component_separators = "|",
                section_separators = "",
                globalstatus = true,
                disabled_filetypes = {
                    statusline = {
                        "dashboard",
                        "lazy",
                        "alpha",
                        "TelescopePrompt",
                    },
                },
                refresh = {
                    statusline = 100,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    "branch",
                    {
                        "diff",
                        symbols = {
                            added = " ",
                            modified = " ",
                            removed = " ",
                        },
                    },
                },
                lualine_c = {
                    {
                        "filetype",
                        icon_only = true,
                        separator = "",
                        padding = {
                            left = 1,
                            right = 0,
                        },
                    },
                    {
                        "filename",
                        path = 1,
                        newfile_status = true,
                        symbols = {
                            modified = "●",
                            readonly = "",
                            unnamed = "",
                        },
                        color = { gui = "bold" },
                    },
                    {
                        -- wakatime
                        function()
                            return vim.g.wakatime_today or ""
                        end,
                        icon = " ",
                    },
                    -- wpm.wpm,
                    -- {
                    --     wpm.historic_graph,
                    --     color = fg("Statement"),
                    -- },
                    -- stylua: ignore
                    -- {
                    --     function() return require("nvim-navic").get_location() end,
                    --     cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
                    -- },
                },
                lualine_x = {
                    -- stylua: ignore
                    -- {
                    --     function() return require("noice").api.status.command.get() end,
                    --     cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                    --     color = fg("Statement")
                    -- },
                    -- stylua: ignore
                    -- {
                    --     function() return require("noice").api.status.mode.get() end,
                    --     cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                    --     color = fg("Constant"),
                    -- },
                    {
                        "diagnostics",
                        symbols = {
                            error = " ",
                            warn = " ",
                            info = " ",
                            hint = " ",
                        },
                    },
                    {
                        function()
                            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
                            for _, client in ipairs(clients) do
                                if client.name ~= "null-ls" then
                                    return client.name
                                end
                            end
                            return "none"
                        end,
                        icon = " ",
                        color = fg("Normal"),
                    },
                },
                lualine_y = {
                    "encoding",
                    "fileformat",
                    "filetype",
                },
                lualine_z = { "location" },
            },
            extensions = {
                "nvim-tree",
                "quickfix",
                "fugitive",
                "toggleterm",
                "trouble",
                "lazy",
                "neo-tree",
            },
        }
    end,
}
