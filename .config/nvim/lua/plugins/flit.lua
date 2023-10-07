return {
    --better f/t motions
    "ggandor/flit.nvim",
    dependencies = {
        "ggandor/leap.nvim", -- better in-buffer navigation
    },
    opts = {
        keys = { f = "f", F = "F", t = "t", T = "T" },
        -- A string like "nv", "nvo", "o", etc.
        labeled_modes = "nv",
        multiline = false,
        -- Like `leap`s similar argument (call-specific overrides).
        -- E.g.: opts = { equivalence_classes = {} }
        opts = {},
    },
}
