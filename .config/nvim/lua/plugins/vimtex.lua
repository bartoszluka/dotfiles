return {
    "lervag/vimtex",
    config = function()
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_quickfix_mode = 0
        -- vim.api.nvim_create_autocmd({
        --     "VimtexEventCompileSuccess",
        --     "VimtexEventCompileFailed",
        -- }, { callback = "TroubleRefresh" })
        vim.keymap.set("n", "<localleader>le", function()
            vim.fn["vimtex#qf#setqflist"]()
            vim.cmd("TroubleToggle quickfix")
        end, { desc = "Show errors", silent = true })
        vim.cmd([[
          augroup VimtexEventCompileFailed
            au!
            au User VimtexEventCompileFailed TroubleRefresh
            au User VimtexEventCompileSuccess TroubleRefresh
          augroup END
        ]])
    end,
}
