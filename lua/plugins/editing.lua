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
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")

			npairs.setup({
				check_ts = true,
				map_break_line = false, -- Do not create undo breaks
				ts_config = {
					lua = { "string" },
					javascript = { "template_string" },
					python = { "comment" },
				},
			})

			-- 1. F-STRING FIX
			-- We handle ' and " specifically to fix f-string behavior
			local quotes = { "'", '"' }
			for _, quote in ipairs(quotes) do
				local rule = npairs.get_rule(quote)
				if rule and rule.with_pair then
					-- Enable pairing if next char is '}' (f-string interpolation)
					rule:with_pair(function(opts)
						if opts.next_char == "}" then
							return true
						end
						return nil
					end)

					-- Enable moving (typing through) even inside f-string braces
					-- We check if the char we typed matches the next char
					rule:with_move(function(opts)
						return opts.char == opts.next_char
					end)
				else
					--Fallback: Create new specific rule for Python if default is missing
					npairs.add_rule(Rule(quote, quote, "python"):with_pair(function(opts)
						if opts.next_char == "}" then
							return true
						end
						return nil
					end):with_move(function(opts)
						return opts.char == opts.next_char
					end))
				end
			end
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

	-- 4. Smart find-replace with (and other stuff)
	{
		"tpope/vim-abolish",
		event = "BufReadPost",
	},
}
