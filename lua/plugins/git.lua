return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			current_line_blame = true, -- Toggle this to see "Blame" text next to the cursor!
			current_line_blame_opts = {
				delay = 500,
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				-- Automatic preview_hunk mode
				local auto_preview_enabled = false
				--
				-- Function to toggle the auto-preview mode
				local function toggle_auto_preview()
					auto_preview_enabled = not auto_preview_enabled
					if auto_preview_enabled then
						print("Hunk Auto-Preview: Enabled")
					else
						print("Hunk Auto-Preview: Disabled")
					end
				end

				-- Keymaps for navigation
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation (Jump between changes)
				map("n", "<leader>gn", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "<leader>gp", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				-- Actions
				map("n", "<leader>gP", gs.preview_hunk, { desc = "Git: Preview Hunk" })
				map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Git: Toggle Blame" })

				map("n", "<leader>gr", function()
					-- If auto-preview is active, close floating windows beforehand
					if auto_preview_enabled then
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							local config = vim.api.nvim_win_get_config(win)
							-- Check if the window is floating (relative is not empty)
							if config.relative ~= "" then
								vim.api.nvim_win_close(win, false)
							end
						end
					end

					local current_win = vim.api.nvim_get_current_win()
					gs.reset_hunk()

					-- Small delay to ensure the reset finishes before we force focus back
					vim.defer_fn(function()
						if vim.api.nvim_win_is_valid(current_win) then
							vim.api.nvim_set_current_win(current_win)
						end
					end, 20)
				end, { desc = "Git: Reset Hunk (No Focus Jump)" })

				-- Create the Autocmd for CursorHold
				vim.api.nvim_create_autocmd("CursorHold", {
					buffer = bufnr,
					callback = function()
						if auto_preview_enabled then
							-- Only attempt preview if there is a hunk at the cursor
							-- focusable = false prevents the cursor from jumping into the popup
							gs.preview_hunk({ focusable = false })
						end
					end,
				})

				-- Keymap to toggle this mode
				vim.keymap.set("n", "<leader>gA", toggle_auto_preview, {
					buffer = bufnr,
					desc = "Git: Toggle Auto Hunk Preview",
				})
			end,
		})

		-- Custom keymap for git commit diff split
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "gitrebase",
			callback = function()
				-- Map 'K' to show the commit under cursor in a vertical split
				vim.keymap.set("n", "K", function()
					local commit = vim.fn.expand("<cword>")
					-- Open a vertical split and read the git show output into it
					vim.cmd("vnew")
					vim.cmd("read !git show " .. commit)
					vim.cmd("setlocal buftype=nofile bufhidden=wipe noswapfile filetype=git")
					vim.cmd("normal! gg") -- Jump to top of the diff
				end, { buffer = true, desc = "Git: Show commit diff in split" })
			end,
		})
	end,
}
