return {
	"nvim-telescope/telescope.nvim",
	config = function()
		require("telescope").setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						-- Only show errors from the active file, and
						-- return to the window that opened telescope
						["<CR>"] = function(prompt_bufnr)
							local action_state = require("telescope.actions.state")
							local entry = action_state.get_selected_entry()
							require("telescope.actions").close(prompt_bufnr)
							local target = entry.path or entry.filename
							if target then
								vim.cmd("drop " .. target)
							end
						end,
					},
				},
				-- Landscape mode
				layout_strategy = "center",
				layout_config = {
					anchor = "S",
					height = 0.35,
					width = 0.90,
					preview_cutoff = 1,
				},
			},
			pickers = {
				diagnostics = {
					initial_mode = "normal", -- Start in normal mode for errors
				},
			},
		})

		-- Keymap for local diagnostics
		vim.keymap.set("n", "<leader>d", function()
			require("telescope.builtin").diagnostics({ bufnr = 0 })
		end, { desc = "[D]iagnostics list (Current Buffer)" })

		-- Standard Search
		vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[F]ind [F]iles" })
		vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "[F]ind by [G]rep" })
		vim.keymap.set("n", "<leader>fr", require("telescope.builtin").oldfiles, { desc = "[F]ind [R]ecent Files" })

		-- Integration with Aerial
		require("telescope").load_extension("aerial")
		vim.keymap.set("n", "<leader>ss", "<cmd>Telescope aerial<CR>", { desc = "[S]earch [S]ymbols (Aerial)" })
	end,
}
