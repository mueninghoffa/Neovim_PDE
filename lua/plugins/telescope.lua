return {
  "nvim-telescope/telescope.nvim",
  config = function()
    require('telescope').setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            -- Use 'drop' to prevent duplicate splits
            ["<CR>"] = function(prompt_bufnr)
              local action_state = require("telescope.actions.state")
              local entry = action_state.get_selected_entry()
              require("telescope.actions").close(prompt_bufnr)
              vim.cmd("drop " .. entry.path)
            end,
          },
        },
      },
    })

    -- Keymaps go OUTSIDE the setup table, but inside the config function
    vim.keymap.set('n', '<leader>d', function()
      require('telescope.builtin').diagnostics({ bufnr = 0 })
    end, { desc = '[D]iagnostics list (Current Buffer)' })
  end,
}
