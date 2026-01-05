return {
	{
		"wfxr/minimap.vim",
		lazy = false, -- Needs to start up early to attach to windows
		init = function()
			-- Configuration options
			vim.g.minimap_width = 10
			vim.g.minimap_auto_start = 1
			vim.g.minimap_auto_start_win_enter = 1
			-- Use block characters for smoother look (optional, comment out for real text)
			-- vim.g.minimap_block_buftypes = {'nofile', 'terminal'}
		end,
		config = function()
			-- Check if the binary exists, if not, warn the user
			if vim.fn.executable("code-minimap") == 0 then
				vim.notify(
					"Minimap: 'code-minimap' binary not found. Run 'cargo install code-minimap'",
					vim.log.levels.WARN
				)
			end

			-- Resist auto-resizing of the minimap window
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "minimap",
				callback = function()
					vim.wo.winfixwidth = true
					vim.wo.winfixheight = true
				end,
			})

			-- Add to the config function in zoomout.lua
			vim.keymap.set("n", "<leader>mr", function()
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "minimap" then
						vim.api.nvim_win_set_width(win, vim.g.minimap_width or 10)
					end
				end
			end, { desc = "Minimap: Reset Width" })
		end,
	},
}
