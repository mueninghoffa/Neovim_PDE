-- C:\Users\YourUser\AppData\Local\nvim\init.lua

-- Basic Options
vim.g.mapleader = " "  -- The most important key! (Spacebar)
vim.opt.number = true
vim.opt.relativenumber = true -- Hybrid line numbers
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.shiftwidth = 4        -- 4 spaces for indent
vim.opt.tabstop = 4
vim.opt.clipboard = "unnamedplus" -- Sync with Windows clipboard
vim.opt.scrolloff = 8 			  -- Start scrolling 8 lines before edge of screen
vim.opt.cursorline = true 		  -- Highlight the line the cursor is on
vim.opt.termguicolors = true
vim.opt.updatetime = 250	  -- Enable 24-bit RGB colors

-- Load Lazy.nvim config
require("config.lazy")