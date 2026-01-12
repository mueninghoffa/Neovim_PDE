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
			{ "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Toggle [A]erial Sidebar" },
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

	-- 3. Mini.nvim (Keymap combos for the home row "mash")
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.keymap").setup({
				combos = {
					{ mode = "i", keys = "hjkl", action = "<Esc>", desc = "Mash home row to escape" },
				},
				timeout = 1000,
			})
		end,
	},

	-- 4. Vim-Sneak: Robust Multiline f/F/t/T
	{
		"justinmk/vim-sneak",
		keys = {
			{ "f", "<Plug>Sneak_f", mode = { "n", "x", "o" }, desc = "Sneak Forward" },
			{ "F", "<Plug>Sneak_F", mode = { "n", "x", "o" }, desc = "Sneak Backward" },
			{ "t", "<Plug>Sneak_t", mode = { "n", "x", "o" }, desc = "Sneak Till Forward" },
			{ "T", "<Plug>Sneak_T", mode = { "n", "x", "o" }, desc = "Sneak Till Backward" },
		},
		config = function()
			-- Ensures ; and , work as expected
			vim.g["sneak#s_next"] = 1
		end,
	},

	-- 5. Treesitter Context (Sticky Headers)
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			enable = true, -- Enable the plugin
			max_lines = 5, -- Sticky window will span up to 5 lines
			min_window_height = 0, -- Always show context regardless of window height
			line_numbers = true, -- Match editor line numbers
			multiline_threshold = 20, -- Max lines to show for a single context
			trim_scope = "outer", -- Discard outer lines if max_lines is exceeded
			mode = "cursor", -- Stick based on cursor position
		},
	},
}
