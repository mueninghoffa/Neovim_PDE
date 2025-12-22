return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 20,
            open_mapping = [[<c-\>]], -- Ctrl + backslash to toggle a generic terminal
            direction = 'float', -- 'vertical' | 'horizontal' | 'tab' | 'float'
            float_opts = {
                border = 'curved',
            }
        })

        -- CUSTOM KEYMAP: Run the current python file
        -- This command gets the current file path, opens a terminal, runs python, and stays open.
        function _G.set_terminal_keymaps()
            local opts = {buffer = 0}
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts) -- Esc to exit insert mode in terminal
        end
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

        -- "Leader + r" to run the current file
        vim.keymap.set("n", "<leader>r", function()
            local cmd = "python " .. vim.fn.expand("%")
            require("toggleterm").exec(cmd, 1, 12, nil, "float") 
            -- Args: command, ID, size, dir, direction
        end, { desc = "Run Current Python File" })
    end
}