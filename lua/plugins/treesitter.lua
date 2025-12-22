return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        -- The require happens INSIDE this function
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = { "python", "lua", "vim", "vimdoc", "javascript", "html" },
            highlight = { enable = true },
        })
    end
}