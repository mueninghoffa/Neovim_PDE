-- =============================================================================
-- EDITING & TERMINAL-STYLE KEYS
-- =============================================================================

-- Ctrl+Backspace to delete whole words (IDE behavior)
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })
vim.keymap.set("i", "<C-H>", "<C-w>", { desc = "Delete word backward (Terminal fix)" })

-- =============================================================================
-- NAVIGATION (CURSORS & PAGING)
-- =============================================================================

-- Better search jumps (Keep result in middle of screen)
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Move visual blocks (Drag code up/down with J/K)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move block down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move block up" })

-- Moving around context
vim.keymap.set("n", "[c", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

-- Patching common typos
vim.cmd([[cabbrev Q q]])
vim.cmd([[cabbrev W w]])
vim.cmd([[cabbrev X x]])

-- Obvious equivalent
vim.cmd([[cabbrev xa wqa]])
