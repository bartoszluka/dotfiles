return {
    "goolord/alpha-nvim",
    config = function()
        local max_width = 55
        local hl1 = "String"
        local hl2 = "Label"

        local function button(sc, txt, keybind, keybind_opts)
            local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

            local opts = {
                position = "center",
                shortcut = sc,
                cursor = 5,
                width = max_width,
                align_shortcut = "right",
                hl_shortcut = "Normal",
                hl = hl2,
            }

            if keybind then
                keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
                opts.keymap = { "n", sc_, keybind, keybind_opts }
            end

            local function on_press()
                local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
                vim.api.nvim_feedkeys(key, "t", false)
            end

            return {
                type = "button",
                val = txt,
                on_press = on_press,
                opts = opts,
            }
        end

        local header = {
            type = "text",
            val = {

                --         [[         ,                  /\.__      _.-\         ]],
                --         [[        /~\,      __       /~    \   ./    \        ]],
                --         [[      ,/  /_\   _/  \    ,/~,_.~'"\ /_\_  /'\       ]],
                --         [[     / \ /## \ / V#\/\  /~8#  # ## V8  #\/8 8\      ]],
                --         [[   /~#'#"#""##V&#&# ##\/88#"#8# #" #\#&"##" ##\     ]],
                --         [[  j# ##### #"#\&&"####/###&  #"#&## #&" #"#&#"#'\   ]],
                --         [[ /#"#"#####"###'\&##"/&#"####"### # #&#&##"#"### \  ]],
                --         [[J#"###"#"#"#"####'\# #"##"#"##"#"#####&"## "#"&"##|\]],

                -- [[                            ⢠⣄                          ]],
                -- [[                          ⠠⣡⣿⣿⣷⣄                        ]],
                -- [[                         ⡀⣰⣿⣿⣿⣿⣿⣧⣄⠄                     ]],
                -- [[                   ⢀     ⣴⣿⣿⢣⢹⡏⡙⣿⣿⣷⣄                    ]],
                -- [[                   ⣰⣿⣦⡀⢀⣼⣿⣿⡏⣾⡆⠇⣷⡹⣿⣿⣿⣷⣄                  ]],
                -- [[                 ⣠⣾⣿⣿⣿⣿⣿⣿⣿⡟⣸⣿⣿⣼⣿⣷⡹⣿⠻⢿⣿⣷⣄                ]],
                -- [[              ⡀⢀⣴⣿⣿⣿⣿⣿⣿⢏⣽⣿⢱⣿⣿⣿⣿⣿⣿⣷⡙⢸⣶⣍⡻⢿⣷⣔              ]],
                -- [[        ⡀    ⣠⣶⣿⢏⡙⣿⣿⣿⡿⢡⣾⢸⢃⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣶⣝⠻⣷⣄            ]],
                -- [[       ⣀⠁ ⢠⠴⡛⢿⡟⣱⣿⣿⣌⢿⢟⣴⣿⣿ ⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣍⡳⢄⡀         ]],
                -- [[      ⢈⠝⠄⣠⣴⣿⣿⣦⣾⣿⣿⣿⣿⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣍⡂        ]],
                -- [[   ⡀⢀⣴⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣄      ]],
                -- [[ ⢠⣾⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣷⣄⡀ ]],
                -- [[⠴⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠦]],

                [[                                                     ]],
                [[                           ⣦⡀                        ]],
                [[                         ⢈⣾⣿⣿⣦⡀                      ]],
                [[                        ⢄⣿⣿⢿⣿⣿⣿⣦⡂                    ]],
                [[                   ⣀   ⣠⣾⣿⡏⡆⢿⣌⢻⣿⣿⣦⡀                  ]],
                [[                 ⢔⣼⣿⣷⣄⣴⣿⣿⡟⣸⣿⡘⣿⣦⢻⣿⣿⣿⣦⡀                ]],
                [[                ⣴⣿⣿⣿⣿⣿⡿⢿⣿⢱⣿⣿⣿⣿⣿⣎⢿⢩⡛⢿⣿⣦⡀              ]],
                [[             ⢀⣠⣾⠿⣿⣿⣿⣿⠟⣼⢸⢇⣿⣿⣿⣿⣿⣿⣿⣆⣼⣿⣷⣌⡻⢿⣦⡀            ]],
                [[           ⣠⣶⣿⡿⣡⣶⣜⣿⣿⢫⣾⣿⠘⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣬⡻⢦⡀          ]],
                [[         ⢀⣪⣵⣦⣉⣼⣿⣿⣿⣮⣵⣿⣿⣿⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣭⡢         ]],
                [[     ⣀⣴⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀      ]],
                [[  ⣠⣾⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⣦⡀  ]],
                [[ ⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀]],

                -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣠⣤⣤⣄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
                -- [[⠀⠀⠀⠀⠀⠀⠀⣀⡴⠾⠛⠋⠉⠉⠁⠈⠉⠉⠙⠛⠷⢦⣄⠀⠀⠀⠀⠀⠀⠀]],
                -- [[⠀⠀⠀⠀⢀⣴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⡀⠀⠀⠀⠀]],
                -- [[⠀⠀⠀⣠⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡀⠈⠻⣄⠀⠀⠀]],
                -- [[⠀⠀⣰⠏⠀⢀⣴⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣦⡀⠹⣆⠀⠀]],
                -- [[⠀⢰⡟⢀⣴⣿⣿⣿⣷⡄⠀⠀⠀⢀⣴⣷⣄⠀⣠⡿⠟⡿⠻⢿⡟⠻⣦⣻⡆⠀]],
                -- [[⠀⣾⣷⡿⢟⣿⠟⣿⠈⠙⢦⣀⣴⣿⣿⣿⣿⣿⣯⡀⠀⠀⠀⠀⠈⠀⠈⠻⣷⠀]],
                -- [[⠀⣿⠋⠀⠜⠁⠀⠈⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⣿⠀]],
                -- [[⠀⢿⡄⠀⠀⠀⠀⠀⣠⣾⡿⣿⣿⢿⡟⢿⣧⠙⣿⠉⠻⢿⣦⡀⠀⠀⠀⢠⣿⠀]],
                -- [[⠀⠸⣧⠀⠀⠀⣠⡾⠋⠁⢠⡟⠁⠈⠀⠈⢻⡄⠈⠀⠀⠀⠉⠻⣦⠀⠀⣸⠇⠀]],
                -- [[⠀⠀⠹⡆⣠⡾⠋⠀⠀⠀⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣴⡟⠀⠀]],
                -- [[⠀⠀⠀⠹⣟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠏⠀⠀⠀]],
                -- [[⠀⠀⠀⠀⠈⠳⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠞⠁⠀⠀⠀⠀]],
                -- [[⠀⠀⠀⠀⠀⠀⠈⠙⠶⣤⣄⣀⡀⠀⠀⠀⠀⢀⣀⣠⣤⠶⠋⠁⠀⠀⠀⠀⠀⠀]],
                -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠛⠛⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],

                -- [[███    ██ ███████  ██████  ██    ██ ██ ███    ███]],
                -- [[████   ██ ██      ██    ██ ██    ██ ██ ████  ████]],
                -- [[██ ██  ██ █████   ██    ██ ██    ██ ██ ██ ████ ██]],
                -- [[██  ██ ██ ██      ██    ██  ██  ██  ██ ██  ██  ██]],
                -- [[██   ████ ███████  ██████    ████   ██ ██      ██]],

                -- [[                               __                ]],
                -- [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
                -- [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
                -- [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
                -- [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
                -- [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
            },
            opts = {
                position = "center",
                type = "ascii",
                hl = hl2,
            },
        }
        --
        -- Button groups
        local quick_link_btns = {
            type = "group",
            val = {
                { type = "text",    val = "quick links", opts = { hl = hl1, position = "center" } },
                { type = "padding", val = 1 },

                button("p", "  Find project", "<cmd>Telescope projects<CR>"),
                button(
                    "f",
                    "  Find file",
                    "<cmd>lua require('telescope').extensions.smart_open.smart_open({ cwd_only = true })<CR>"
                ),
                button("r", "  Recently used files", "<cmd>Telescope oldfiles<CR>"),
                button("t", "  Find text", "<cmd>Telescope live_grep<CR>"),
            },
            opts = {
                hl = hl2,
                position = "center",
            },
        }

        local config_btns = {
            type = "group",
            val = {
                { type = "text",    val = "configs", opts = { hl = hl1, position = "center" } },
                { type = "padding", val = 1 },
                button("c", "  Neovim config", "<cmd>edit $MYVIMRC <CR>"),
                button("x", "  xmonad config", "<cmd>edit $HOME/.config/xmonad/src/xmonad.hs<CR>"),
                button("s", "  fish", "<cmd>edit ~/.config/fish/config.fish<CR>"),
                button("i", "  Kitty", "<cmd>edit ~/.config/kitty/kitty.conf<CR>"),
            },
            opts = {
                position = "center",
                hl = hl2,
            },
        }
        local misc_btns = {
            type = "group",
            val = {
                button("q", " Quit", "<cmd>qa<CR>"),
            },
            opts = {
                position = "center",
            },
        }

        local footer = {
            type = "text",
            val = "have fun :)",
            opts = {
                position = "center",
                hl = hl1,
            },
        }

        local config = {
            layout = {
                { type = "padding", val = 2 },
                header,
                { type = "padding", val = 3 },
                quick_link_btns,
                { type = "padding", val = 1 },
                config_btns,
                { type = "padding", val = 2 },
                misc_btns,
                { type = "padding", val = 3 },
                footer,
            },
            opts = {
                noautocmd = true,
                redraw_on_resize = true,
            },
        }
        -- dashboard.section.footer.opts.hl = "Type"
        -- dashboard.section.header.opts.hl = "Include"
        -- dashboard.section.buttons.opts.hl = "Keyword"
        -- vim.cmd([[autocmd User AlphaReady echo 'ready']])
        require("alpha").setup(config)
    end,
}
