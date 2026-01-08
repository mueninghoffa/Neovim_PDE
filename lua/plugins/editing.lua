return {
	-- 1. Commenting
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	-- 2. Auto-closing delimiters
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
			-- Integrate with nvim-cmp
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	-- 3. Surround text with delimiters
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
}

