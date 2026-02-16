return {
	-- 1. Aerial: Sidebar Outline
	{
		"stevearc/aerial.nvim",
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			close_on_select = true,
			backends = { "treesitter", "lsp", "markdown", "man" },
			layout = {
				max_width = { 40, 0.2 },
				min_width = 10,
			},
		},
		keys = {
			{ "<leader>a", "<cmd>AerialToggle<CR>", desc = "Toggle [A]erial Sidebar" },
		},
	},

	-- 2. Navbuddy: Popup Navigator
	{
		"SmiteshP/nvim-navbuddy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			lsp = { auto_attach = true },
		},
		keys = {
			{ "<leader>nv", "<cmd>Navbuddy<CR>", desc = "[N][V]buddy Navigator" },
		},
	},

	-- 3. Better Escape (FIXED for v2.0+ Syntax)
	-- The plugin now requires a nested table structure for mappings.
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup({
				timeout = 200, -- 200ms interval to detect the mash
				default_mappings = false, -- We disable defaults to strictly use our mash list
				mappings = {
					-- 'i' for Insert Mode
					i = {
						j = {
							-- If you type 'j' then 'k', map to Escape
							k = "<Esc>",
							-- If you type 'j' then 'l', map to Escape
							l = "<Esc>",
						},
						k = {
							-- If you type 'k' then 'j', map to Escape
							j = "<Esc>",
						},
						l = {
							-- If you type 'l' then 'j', map to Escape
							j = "<Esc>",
						},
					},
					-- 'v' for Visual Mode
					v = {
						j = {
							-- If you type 'j' then 'k', map to Escape
							k = "<Esc>",
							-- If you type 'j' then 'l', map to Escape
							l = "<Esc>",
						},
						k = {
							-- If you type 'k' then 'j', map to Escape
							j = "<Esc>",
						},
						l = {
							-- If you type 'l' then 'j', map to Escape
							j = "<Esc>",
						},
					},
				},
			})
		end,
	},

	-- 4. Flash.nvim
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			modes = {
				char = {
					enabled = true,
					multi_line = true, -- Enable full-screen search for f/F/t/T
				},
				search = { -- Use flash interface with "/" search
					enabled = true,
				},
			},
		},
		keys = {
			-- 1. Standard Flash Jump (Keep on 's')
			{
				"<CR>",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			-- 2. Treesitter Select (Leader+S)
			{
				"<leader>S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
		},
	},
}
