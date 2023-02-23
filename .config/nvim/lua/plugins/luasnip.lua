return {
    "L3MON4D3/LuaSnip",
    -- Snippet Engine and Snippet Expansion
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    },
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
    end,
    opts = {
        history = true,
        delete_check_events = "TextChanged",
    },
}
