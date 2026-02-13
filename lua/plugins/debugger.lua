return {
	-- 1. The Core Debugger
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio", -- Required dependency for dap-ui
			"mfussenegger/nvim-dap-python", -- Bridges `debugpy` to nvim-dap
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- SETUP UI
			dapui.setup()

			-- SETUP PYTHON
			local dap_python = require("dap-python")

			-- path to debug adapter in conda env
			local debugpy_path = vim.g.python3_host_prog

			-- fallback logic (OS-aware)
			if not debugpy_path or vim.fn.filereadable(debugpy_path) == 0 then
				local is_windows = vim.fn.has("win32") == 1
				local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv"
				local debugpy_path = mason_path .. (is_windows and "/Scripts/python.exe" or "/bin/python")
			end

			dap_python.setup(debugpy_path)

			-- correct python installation
			-- force it to use the 'python' command currently active in shell
			dap_python.resolve_python = function()
				return vim.fn.exepath("python")
			end

			-- AUTO OPEN/CLOSE UI
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- KEYMAPS
			-- For moving between breakpoints
			local function goto_breakpoint(direction)
				local valid_directions = { next = true, prev = true }
				if not valid_directions[direction] then
					error("direction must be 'next' or 'prev'. Received:" .. tostring(direction))
				end

				local breakpoints = require("dap.breakpoints").get(vim.api.nvim_get_current_buf())[1]
				local cur_line = vim.api.nvim_win_get_cursor(0)[1]

				if not breakpoints then
					print("No breakpoints set in this buffer")
					return
				end

				local lines = {}
				for _, bp in ipairs(breakpoints) do
					table.insert(lines, bp["line"])
				end

				table.sort(lines)

				local closest = { next = nil, prev = nil }
				if cur_line < lines[1] then
					closest["next"] = lines[1]
				elseif cur_line > lines[#lines] then
					closest["prev"] = lines[#lines]
				else
					for i, line in ipairs(lines) do
						if line == cur_line then
							closest["next"] = lines[i + 1]
							closest["prev"] = lines[i - 1]
							break
						end
						if line > cur_line then
							closest["next"] = line
							closest["prev"] = lines[i - 1]
							break
						end
					end
				end

				if not closest[direction] then
					print("No " .. tostring(direction) .. " breakpoint")
					return
				end

				vim.api.nvim_win_set_cursor(0, { closest[direction], 0 })
			end

			-- Toggle Breakpoint (Leader + b)
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })

			-- Start / Continue (F5)
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })

			-- Step Over (F9)
			vim.keymap.set("n", "<F9>", dap.step_over, { desc = "Debug: Step Over" })

			-- Step Into (F10)
			vim.keymap.set("n", "<F10>", dap.step_into, { desc = "Debug: Step Into" })

			--Toggle Dap UI
			vim.keymap.set("n", "<leader>bt", dapui.toggle, { desc = "Debug: Toggle UI" })

			-- Next breakpoint
			vim.keymap.set("n", "<leader>bn", function()
				goto_breakpoint("next")
			end, { desc = "Debug: Goto Next Breakpoint" })

			-- Prev breakpoint
			vim.keymap.set("n", "<leader>bp", function()
				goto_breakpoint("prev")
			end, { desc = "Debug: Goto Prev Breakpoint" })
		end,
	},
}
