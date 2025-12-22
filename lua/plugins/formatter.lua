return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                python = { "isort", "black" }, -- Run isort first, then black
                lua = { "stylua" },
            },
			formatters = {
                isort = {
                    -- explicitly set args to avoid the broken auto-detected --line-ending flag
                    args = { "--stdout", "--filename", "$FILENAME", "-" },
                },
			},
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 2000,
            },
        })
    end
}