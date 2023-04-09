return {
    "jcdickinson/codeium.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
        {
            "jcdickinson/http.nvim",
            build = "cargo build --workspace --release",
        },
    },
    config = function()
        require("codeium").setup({})
    end,
    -- "Exafunction/codeium.vim",
    -- config = function()
    --     vim.g.codeium_disable_bindings = 1
    --     vim.g.codeium_filetypes = { telescope = false }
    --     vim.keymap.set("i", "<c-l>", vim.fn["codeium#Accept"], { expr = true, silent = true })
    --     vim.keymap.set("i", "<c-f>", vim.fn["codeium#Accept"], { expr = true, silent = true })
    --     vim.keymap.set("i", "<c-;>", function()
    --         return vim.fn["codeium#CycleCompletions"](1)
    --     end, { expr = true, silent = true })
    --     vim.keymap.set("i", "<c-,>", function()
    --         return vim.fn["codeium#CycleCompletions"](-1)
    --     end, { expr = true, silent = true })
    --     vim.keymap.set("i", "<c-x>", vim.fn["codeium#Clear"], { expr = true, silent = true })
    -- end,
}
