return {
    "freddiehaddad/feline.nvim",
    dependencies = { "lewis6991/gitsigns.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local themes = {
            melange = {
                background = "#292522",
                foreground = "#ECE1D7",
                color0 = "#34302C",
                color1 = "#BD8183",
                color2 = "#78997A",
                color3 = "#E49B5D",
                color4 = "#7F91B2",
                color5 = "#B380B0",
                color6 = "#7B9695",
                color7 = "#C1A78E",
                color8 = "#867462",
                color9 = "#D47766",
                color10 = "#85B695",
                color11 = "#EBC06D",
                color12 = "#A3A9CE",
                color13 = "#CF9BC2",
                color14 = "#89B3B6",
                color15 = "#ECE1D7",
            },
            nord = {
                -- # Nord Colorscheme
                -- # Based on:
                -- # - https://gist.github.com/marcusramberg/64010234c95a93d953e8c79fdaf94192
                -- # - https://github.com/arcticicestudio/nord-hyper
                foreground = "#D8DEE9",
                -- background = "#2E3440",
                background = "#3B4252",
                color0 = "#3B4252",
                color1 = "#BF616A",
                color2 = "#A3BE8C",
                color3 = "#D08770",
                color4 = "#81A1C1",
                color5 = "#B48EAD",
                color6 = "#88C0D0",
                color7 = "#D8DEE9",
                color8 = "#4C566A",
                color9 = "#BF616A",
                color10 = "#A3BE8C",
                color11 = "#EBCB8B",
                color12 = "#5E81AC",
                color13 = "#B48EAD",
                color14 = "#8FBCBB",
                color15 = "#ECEFF4",
            },
        }
        local function fg(color, bg)
            if bg then
                return { fg = color, bg = bg }
            else
                return { fg = color }
            end
        end
        local function from_group(name, bg)
            local hl = vim.api.nvim_get_hl(0, { name = name })
            local hex = string.format("#%x", hl.fg)

            if bg then
                return { fg = hex, bg = bg }
            else
                return { fg = hex }
            end
        end
        -- check wakatime every 2 minutes and update a global variable
        local timer = vim.loop.new_timer()
        if timer then
            timer:start(
                0,
                2 * 60 * 1000, -- 2 minutes
                vim.schedule_wrap(function()
                    vim.fn.jobstart({ "/home/bartek/.wakatime/wakatime-cli", "--today" }, {
                        stdout_buffered = true,
                        on_stdout = function(_, data)
                            local time_today = vim.trim(data[1])
                            vim.g.wakatime_today = time_today
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
                    timer:close()
                end
            end,
        }, { create_group = "StopWakaTimeChecking" })

        vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" })
        local function colors(theme)
            return {
                bg = theme.background,
                bright_bg = theme.color0,
                fg = theme.foreground,
                black = theme.color0,
                bright_black = theme.color8,
                red = theme.color1,
                bright_red = theme.color9,
                green = theme.color2,
                bright_green = theme.color10,
                yellow = theme.color3,
                bright_yellow = theme.color11,
                blue = theme.color4,
                bright_blue = theme.color12,
                magenta = theme.color5,
                bright_magenta = theme.color13,
                cyan = theme.color6,
                bright_cyan = theme.color14,
                white = theme.color7,
                bright_white = theme.color15,
            }
        end
        local vi_mode_colors = {
            NORMAL = "bright_cyan",
            INSERT = "white",
            VISUAL = "bright_cyan",
            LINES = "bright_cyan",
            BLOCK = "bright_cyan",
            REPLACE = "bright_yellow",
            ["V-REPLACE"] = "bright_yellow",
            -- not defined
            COMMAND = "white",
            OP = "green",
            ENTER = "cyan",
            MORE = "cyan",
            SELECT = "bright_red",
            SHELL = "green",
            TERM = "green",
            NONE = "yellow",
        }
        local macros = {
            provider = require("recorder").displaySlots,
            hl = fg("bright_cyan"),
            left_sep = " ",
        }
        local vi_mode = {
            provider = {
                name = "vi_mode",
                opts = {
                    show_mode_name = true,
                    padding = "center",
                },
            },
            icon = "",
            hl = function()
                return {
                    name = require("feline.providers.vi_mode").get_mode_highlight_name(),
                    fg = "bg",
                    bg = require("feline.providers.vi_mode").get_mode_color(),
                    -- style = "bold",
                }
            end,
        }

        local git_branch = {
            provider = "git_branch",
            hl = fg("magenta"),
            left_sep = "block",
            right_sep = "block",
        }

        local git_diff_added = {
            provider = "git_diff_added",
            hl = from_group("GitSignsAdd"),
        }

        local git_diff_removed = {
            provider = "git_diff_removed",
            hl = from_group("GitSignsDelete"),
        }

        local git_diff_changed = {
            provider = "git_diff_changed",
            hl = from_group("GitSignsChange"),
        }
        local diagnostic_errors = {
            provider = "diagnostic_errors",
            hl = from_group("DiagnosticError"),
        }
        local diagnostic_warnings = {
            provider = "diagnostic_warnings",
            hl = from_group("DiagnosticWarn"),
        }
        local diagnostic_hints = {
            provider = "diagnostic_hints",
            hl = from_group("DiagnosticHint"),
        }
        local diagnostic_info = {
            provider = "diagnostic_info",
            hl = from_group("DiagnosticInfo"),
        }

        local full_file_name = {
            provider = {
                name = "file_info",
                opts = {
                    type = "relative",
                    file_readonly_icon = "  ",
                },
            },
            hl = {
                style = "bold",
            },
        }
        local file_info = {
            provider = {
                name = "file_info",
                opts = {
                    -- type = "relative",
                    file_readonly_icon = "  ",
                    type = "relative-short",
                },
            },
            hl = {
                style = "bold",
            },
            left_sep = "block",
            right_sep = "block",
        }
        local lsp_client_names = {
            provider = "lsp_client_names",
            hl = fg("cyan"),
            left_sep = "block",
            right_sep = "block",
        }

        local file_type = {
            provider = {
                name = "file_type",
                opts = {
                    filetype_icon = true,
                    case = "lowercase",
                },
            },
            hl = fg("bright_magenta"),
            left_sep = "block",
            right_sep = "block",
        }
        local file_encoding = {
            provider = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc,
            hl = fg("bright_yellow"),
            left_sep = "block",
            right_sep = "block",
        }
        local position = {
            provider = "position",
            hl = {
                fg = "green",
                bg = "bright_bg",
                -- style = "bold",
            },
            left_sep = "block",
            right_sep = "block",
        }

        vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }, function(output)
            if output.code == 0 then
                vim.g.base_dir = vim.fs.basename(vim.trim(output.stdout))
            end
        end)
        local git_repo_or_base_directory = {
            provider = function()
                return vim.g.base_dir or vim.fs.basename(vim.fn.getcwd() or "")
            end,
            -- hl = fg("white"),
        }
        local selected_lines = {
            provider = function()
                local mode = vim.api.nvim_get_mode().mode
                if
                    mode == "v" -- character
                    or mode == "V" -- lines
                    or mode == "" -- block
                then
                    local line_number_start = vim.fn.line("v")
                    local line_number_end = vim.fn.line(".")
                    local diff = vim.fn.abs(line_number_start - line_number_end)
                    return string.format("| %d", diff + 1)
                end
                return ""
            end,
            hl = fg("green"),
        }

        -- Initialize the components table

        local bar = {
            provider = "┃",
            hl = {
                fg = "yellow",
                bg = "bright_bg",
            },
            left_sep = "block",
            right_sep = "block",
        }
        local separators = {
            vertical_bar = "┃",
            vertical_bar_thin = "│",
            block = "█",
            space = " ",
        }
        local wakatime = {
            provider = function()
                return vim.g.wakatime_today or "..."
            end,
            icon = {
                str = "  ",
                hl = {
                    style = "bold",
                },
            },
            hl = fg("cyan"),
        }
        local components = {
            active = {
                {
                    vi_mode,
                    git_branch,
                    git_diff_added,
                    git_diff_removed,
                    git_diff_changed,
                    wakatime,
                    macros,
                },
                {
                    file_info,
                },
                {
                    diagnostic_errors,
                    diagnostic_warnings,
                    diagnostic_hints,
                    diagnostic_info,
                    lsp_client_names,
                    file_type,
                    file_encoding,
                    position,
                    selected_lines,
                },
            },
            inactive = {
                {},
                {
                    file_info,
                },
                {},
            },
        }
        --  vim.g.colors_name
        require("feline").setup({
            components = components,
            theme = colors(themes.nord),
            vi_mode_colors = vi_mode_colors,
            force_inactive = {
                filetypes = {
                    "^no-neck-pain$",
                    "^neo-tree$",
                    "^packer$",
                    "^fugitive$",
                    "^fugitiveblame$",
                    "^qf$",
                    "^starter$",
                    "^help$",
                },
                buftypes = {
                    "^prompt$",
                    "^nofile$",
                },
            },
        })
        require("feline").winbar.setup({
            components = {
                active = {
                    { full_file_name },
                    { git_repo_or_base_directory },
                },
            },

            disable = {
                "^starter$",
                "^no-neck-pain$",
                "^neo-tree$",
                "^help$",
            },
        })
    end,
}
