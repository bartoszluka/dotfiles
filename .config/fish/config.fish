if status is-interactive # Commands to run in interactive sessions can go here

    # match colors of the terminal in fish
    set -U fish_color_autosuggestion brblack
    set -U fish_color_cancel -r
    set -U fish_color_command brgreen
    set -U fish_color_comment brmagenta
    set -U fish_color_cwd green
    set -U fish_color_cwd_root red
    set -U fish_color_end brmagenta
    set -U fish_color_error brred
    set -U fish_color_escape brcyan
    set -U fish_color_history_current --bold
    set -U fish_color_host normal
    set -U fish_color_match --background=brblue
    set -U fish_color_normal normal
    set -U fish_color_operator cyan
    set -U fish_color_param brblue
    set -U fish_color_quote yellow
    set -U fish_color_redirection bryellow
    set -U fish_color_search_match bryellow '--background=brblack'
    set -U fish_color_selection white --bold '--background=brblack'
    set -U fish_color_status red
    set -U fish_color_user brgreen
    set -U fish_color_valid_path --underline
    set -U fish_pager_color_completion normal
    set -U fish_pager_color_description yellow
    set -U fish_pager_color_prefix white --bold --underline
    set -U fish_pager_color_progress brwhite '--background=cyan'

    # some useful abbrieviations
    abbr --add quit exit
    abbr --add q exit
    abbr --add :q exit
    abbr --add cdc cd ~/.config
    abbr --add lg lazygit
    abbr --add lg lazygit

    abbr --add ins 'paru -S'
    abbr --add upd 'paru -Syyu'
    abbr --add uns 'paru -Rns'

    abbr --add kl killall
    abbr --add chx 'chmod +x'
    abbr --add keyring 'paru -Sy archlinux-keyring'

    # run matlab from the commandline (the only way it works for some reason)
    abbr --add matl 'matlab &> /dev/null & disown'

    # hoogle and haddock
    abbr --add gen-hoogle 'stack test --fast --haddock-deps && stack hoogle -- generate --local'
    abbr --add hg 'stack hoogle -- server --local --port=8080'

    fish_add_path --path ~/.local/bin/
    fish_add_path --path ~/.cabal/bin/
    fish_add_path --path ~/.ghcup/bin/
    fish_add_path --path ~/.ghcup/bin/
    fish_add_path --path /home/linuxbrew/.linuxbrew/bin

    # bat as a manpager
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx PAGER less

    # set lvim as editor
    set -gx EDITOR nvim
    set -gx VISUAL nvim

    # prettify help printing
    alias bathelp 'bat --plain --language=help'
    function h -d "append --help and pipe into bat"
        $argv --help 2>&1 | bathelp
    end

    alias rm 'gio trash'

    function unrm -d "restore deleted file"
        gio trash --list | fzf | cut -f1 | xargs gio trash --restore
    end

    # thefuck --alias | source
    # uncomment if there are aliases for common commands
    # e.g. sed -> gsed or git -> hub 
    # set -x THEFUCK_OVERRIDEN_ALIASES 'gsed,git'

    # set -g fish_key_bindings fish_hybrid_key_bindings
    set -g fish_key_bindings fish_vi_key_bindings

    # ctrl+o goes back a directory in normal and insert mode
    for mode in default insert
        bind -M $mode \co 'prevd; commandline -f repaint'
    end
    bind -M insert \cf forward-char

    # speed up keyboard input
    # xset r rate 220 30

    function tere
        set --local result (command tere $argv)
        [ -n "$result" ] && cd -- "$result"
    end


    # prompt
    set -g hydro_symbol_prompt λ
    # set -g hydro_symbol_prompt ➜
    # set -g hydro_symbol_git_dirty " ✗"
    # 
    set -g hydro_symbol_git_ahead "↑"
    set -g hydro_symbol_git_behind "↓"
    set -g hydro_symbol_git_dirty " •"
    set -g hydro_color_git magenta
    set -g hydro_color_pwd cyan
    set -g hydro_color_duration yellow

    # for node version manager (nvm)
    set -g nvm_default_version latest

    # for sumo
    set -g SUMO_HOME /usr/share/sumo
    set -g NEOVIDE_MULTIGRID true
    alias ls exa

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    function conda-start
        if test -f /opt/miniconda3/bin/conda
            eval /opt/miniconda3/bin/conda "shell.fish" hook $argv | source
        end
    end
    # <<< conda initialize <<<

    # 'z' is a better cd that remembers directories
    zoxide init fish | source

    # use common trash locaction for rip
    set -gx GRAVEYARD ~/.local/share/Trash
    # alias rip 'rip --graveyard ~/.local/share/Trash'

end
