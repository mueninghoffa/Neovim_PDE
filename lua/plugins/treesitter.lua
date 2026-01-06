return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		-- Force compiler on windows
		if vim.fn.has("win32") == 1 then
			vim.env.CC = "gcc"
		end

		local configs = require("nvim-treesitter.config")

		configs.setup({
			ensure_installed = { "python", "lua", "vim", "vimdoc", "javascript", "html" },
			highlight = { enable = true },
		})
	end,
}
