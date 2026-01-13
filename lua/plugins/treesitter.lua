return {
	-- 1. Main Treesitter Plugin
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" }, -- Lazy load on file open
		config = function()
			-- Force compiler on windows
			if vim.fn.has("win32") == 1 then
				vim.env.CC = "gcc"
			end

			local configs = require("nvim-treesitter.config")

			configs.setup({
				ensure_installed = { "python", "lua", "vim", "vimdoc", "javascript", "html", "yaml", "json" },
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- 2. Treesitter Context (Sticky Headers)
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPost",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			enable = true,
			max_lines = 5,
			trim_scope = "outer",
			mode = "cursor",
		},
	},
}
