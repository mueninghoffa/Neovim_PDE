-- Basic Options
vim.g.mapleader = " " -- The most important key! (Spacebar)
vim.opt.number = true
vim.opt.relativenumber = true -- Hybrid line numbers
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4 -- 4 spaces for indent
vim.opt.tabstop = 4
vim.opt.clipboard = "unnamedplus" -- Sync with Windows clipboard
vim.opt.scrolloff = 5 -- Start scrolling 8 lines before edge of screen
vim.opt.cursorline = true -- Highlight the line the cursor is on
vim.opt.termguicolors = true
vim.opt.updatetime = 250 -- Enable 24-bit RGB colors

vim.g.loaded_netrw = 1 -- manually disable netrw to prevent conflicts
vim.g.loaded_netrwPlugin = 1

-- Use the neovim conda environment (OS-aware)
local function setup_neovim_env()
	local home = vim.fn.expand("~")
	local is_windows = vim.fn.has("win32") == 1
	local conda_names = { "miniconda3", "anaconda3", ".conda" }

	for _, name in ipairs(conda_names) do
		-- Normalize slashes for the current OS
		local base_path = home
			.. (is_windows and "\\" or "/")
			.. name
			.. (is_windows and "\\envs\\neovim" or "/envs/neovim")
		local python_bin = is_windows and (base_path .. "\\python.exe") or (base_path .. "/bin/python")

		if vim.fn.executable(python_bin) == 1 then
			-- 1. Set the host prog for Neovim's internal python support
			vim.g.python3_host_prog = python_bin

			-- 2. Inject the env's folders into PATH for Mason and other tools
			local sep = is_windows and ";" or ":"
			if is_windows then
				-- Windows: python.exe is in root, but pip and tools are in /Scripts
				local scripts = base_path .. "\\Scripts"
				vim.env.PATH = base_path .. sep .. scripts .. sep .. vim.env.PATH
			else
				-- Linux: both python and pip are in /bin
				local bin = base_path .. "/bin"
				vim.env.PATH = bin .. sep .. vim.env.PATH
			end
			return python_bin
		end
	end

	-- Fallback: If 'neovim' env isn't found, try to find a system python
	local fallback = vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or vim.fn.exepath("python")
	return fallback
end
-- Run the setup and store the path
local neovim_python = setup_neovim_env()
vim.g.python3_host_prog = neovim_python

-- install lazyvim if it is not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("config.lazy")

-------------------------------------------------------------------------------
-- 1. SILENCE UNUSED PROVIDERS
-- This stops :checkhealth from complaining about missing Node/Perl/Ruby
-------------------------------------------------------------------------------
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-------------------------------------------------------------------------------
-- 2. AUTO-INSTALL MASON TOOLS
-- Automatically installs tools if they are missing (Great for new machines!)
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- Only run if Mason is loaded
		local registry_avail, registry = pcall(require, "mason-registry")
		if not registry_avail then
			return
		end

		local tools_to_install = {
			"black", -- Python formatter
			"isort", -- Python import sorter
			"debugpy", -- Python debugger
			"stylua", -- Lua formatter
			"jupytext", -- Jupyter notebook conversion
			"tree-sitter-cli", -- Needed for syntax highlighting updates
			"yamlfmt", -- YAML formatter
		}

		registry.refresh(function()
			for _, tool in ipairs(tools_to_install) do
				if registry.has_package(tool) then
					local p = registry.get_package(tool)
					if not p:is_installed() then
						vim.notify("🚀 Installing missing tool: " .. tool, vim.log.levels.INFO)
						p:install()
					end
				else
					vim.notify("⚠️ Mason tool not found: " .. tool, vim.log.levels.WARN)
				end
			end
		end)
	end,
})

-- Force-start Treesitter for Python files to bypass auto-attach failure
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python", "lua", "rust", "yaml" }, -- Add other languages if they fail too
	callback = function()
		local status_ok, _ = pcall(vim.treesitter.start)
		if not status_ok then
			-- Optional: print silently to debug if needed, but usually safe to ignore
		end
	end,
})
require("config.keymaps")
