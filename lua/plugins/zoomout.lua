return {
	{
		"wfxr/minimap.vim",
		lazy = false,
		init = function()
			-- Tweak this number if you feel the minimap is too wide/empty
			vim.g.minimap_width = 10
			vim.g.minimap_auto_start = 1
			vim.g.minimap_auto_start_win_enter = 1
		end,
		config = function()
			-- 1. Binary Check
			if vim.fn.executable("code-minimap") == 0 then
				vim.notify("Minimap binary not found", vim.log.levels.WARN)
			end

			-- 2. Prevent Auto-Resizing (Locks the window dimensions)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "minimap",
				callback = function()
					vim.wo.winfixwidth = true
					vim.wo.winfixheight = true

					-- SAFETY FIX: Intercept the ':q' command
					-- This protects you if you habitually type :q to close windows.
					-- It converts ':q' into ':wincmd p' (switch window) only for this buffer.
					vim.cmd("cnoreabbrev <buffer> <expr> q getcmdtype() == ':' ? 'wincmd p' : 'q'")
					vim.cmd("cnoreabbrev <buffer> <expr> wq getcmdtype() == ':' ? 'wincmd p' : 'wq'")
					vim.cmd("cnoreabbrev <buffer> <expr> x getcmdtype() == ':' ? 'wincmd p' : 'x'")
				end,
			})

			-------------------------------------------------------------------
			-- 3. CYCLE-FRIENDLY RESCUE (Pass-Through)
			-------------------------------------------------------------------
			vim.g.minimap_intentional_focus = false

			vim.api.nvim_create_autocmd("WinEnter", {
				pattern = "*",
				callback = function()
					if vim.bo.filetype == "minimap" and not vim.g.minimap_intentional_focus then
						vim.schedule(function()
							if vim.bo.filetype == "minimap" then
								-- Just cycle to the NEXT window
								vim.cmd("wincmd w")
							end
						end)
					end
				end,
			})

			vim.api.nvim_create_autocmd("WinLeave", {
				pattern = "*",
				callback = function()
					if vim.bo.filetype == "minimap" then
						vim.g.minimap_intentional_focus = false
					end
				end,
			})

			-------------------------------------------------------------------
			-- 4. Keymaps
			-------------------------------------------------------------------

			-- Focus (Intentional)
			vim.keymap.set("n", "<leader>mf", function()
				vim.g.minimap_intentional_focus = true
				local wins = vim.api.nvim_list_wins()
				for _, win in ipairs(wins) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "minimap" then
						vim.api.nvim_set_current_win(win)
						return
					end
				end
				-- If closed, open it and focus
				vim.cmd("Minimap")
				vim.g.minimap_intentional_focus = true
			end, { desc = "Minimap: Focus" })

			-- CRASH-PROOF HARD RESET (<leader>mr)
			vim.keymap.set("n", "<leader>mr", function()
				-- 1. If we are currently IN the minimap, get out first!
				-- Closing the window while inside it causes the E957 crash.
				local current_win = vim.api.nvim_get_current_win()
				local buf = vim.api.nvim_win_get_buf(current_win)
				if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "minimap" then
					vim.cmd("wincmd p") -- Jump to previous window
				end

				-- 2. Now it is safe to restart
				vim.schedule(function()
					vim.cmd("MinimapClose")
					vim.schedule(function()
						vim.cmd("Minimap")
						-- Ensure we didn't get sucked back in
						vim.cmd("wincmd p")
					end)
				end)
			end, { desc = "Minimap: Hard Reset" })
		end,
	},
}
