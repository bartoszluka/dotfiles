return {
    "tpope/vim-fugitive",
    config = function()
        -- for yadm to work
        vim.cmd([[
                function! YadmComplete(A, L, P) abort
                    return fugitive#Complete(a:A, a:L, a:P, {'git_dir': expand("~/.local/share/yadm/repo.git")})
                endfunction
            ]])
        vim.cmd([[
                command! -bang -nargs=? -range=-1 -complete=customlist,YadmComplete Yadm exe
                    \ fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>,
                    \ { 'git_dir': expand("~/.local/share/yadm/repo.git") })
            ]])

        local yadm_git = function(on_yadm, on_git)
            local function is_in_dot_config()
                for dir in vim.fs.parents(vim.api.nvim_buf_get_name(0)) do
                    if vim.fn.isdirectory(dir .. "/.config") == 1 then
                        return true
                    end
                end
                return false
            end

            return function()
                if is_in_dot_config() then
                    vim.cmd(on_yadm)
                else
                    vim.cmd(on_git)
                end
            end
        end
        nx.map({
            { "<leader>gg", yadm_git("Yadm", "Git"),                  desc = "git fugitive ui" },
            { "<leader>gw", yadm_git("write | Yadm add --force %", "Gwrite"), desc = "git add current file" },
            { "<leader>gP", yadm_git("Yadm push", "Git push"),        desc = "git push" },
        })
    end,
}
