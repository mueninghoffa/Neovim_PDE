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

	-- 4. Vim-Sneak: Refined for better highlighting
	{
		"justinmk/vim-sneak",
		keys = {
			{ "f", "<Plug>Sneak_f", mode = { "n", "x", "o" }, desc = "Sneak Forward" },
			{ "F", "<Plug>Sneak_F", mode = { "n", "x", "o" }, desc = "Sneak Backward" },
			{ "t", "<Plug>Sneak_t", mode = { "n", "x", "o" }, desc = "Sneak Till Forward" },
			{ "T", "<Plug>Sneak_T", mode = { "n", "x", "o" }, desc = "Sneak Till Backward" },
		},
		config = function()
			-- 1. Use ; and , for next/previous
			vim.g["sneak#s_next"] = 1

			-- 2. Highlight ALL matches on the screen (both directions)
			vim.g["sneak#label"] = 0 -- Ensure labels are off if you prefer pure character search
			vim.g["sneak#use_ic_scs"] = 1 -- Case insensitive search

			-- 3. The "Modern IDE" Highlight: highlight all occurrences immediately
			-- This makes it behave more like a 'find' in a browser
			vim.g["sneak#prompt"] = "Sneak: "

			-- This setting ensures that search results stay highlighted until you move
			vim.cmd([[
              highlight Sneak guifg=black guibg=#00ff00 ctermfg=black ctermbg=green
              highlight SneakScope guifg=black guibg=#00ffff ctermfg=black ctermbg=cyan
            ]])
		end,
	},
}
