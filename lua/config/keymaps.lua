-- =============================================================================
-- EDITING & TERMINAL-STYLE KEYS
-- =============================================================================

-- Ctrl+Backspace to delete whole words
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })
vim.keymap.set("i", "<C-H>", "<C-w>", { desc = "Delete word backward (Terminal fix)" })

-- Ctrl+Delete to delete whole words
vim.keymap.set("i", "<C-Del>", "<C-o>dw", { desc = "Delete word forwards" })

-- =============================================================================
-- NAVIGATION (CURSORS & PAGING)
-- =============================================================================

-- Better search jumps (Keep result in middle of screen)
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Normal Mode: Move current line
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Visual Mode: Move selected block
-- gv=gv re-selects the block and fixes indentation
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Insert Mode: Move line while typing
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })

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
