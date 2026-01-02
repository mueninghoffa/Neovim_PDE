return {
  "nvim-telescope/telescope.nvim",
  config = function()
    require('telescope').setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<CR>"] = function(prompt_bufnr)
              local action_state = require("telescope.actions.state")
              local entry = action_state.get_selected_entry()
              require("telescope.actions").close(prompt_bufnr)
              local target = entry.path or entry.filename
              if target then
                vim.cmd("drop " .. target)
              end
            end,
          },
        },
        -- Landscape mode
        layout_strategy = 'center',
        layout_config = {
            anchor = 'S',
            height = 0.35,
            width = 0.90,
            preview_cutoff = 1,
        }
      },
      pickers = {
        diagnostics = {
          initial_mode = "normal", -- Start in normal mode for errors
        },
      },
    })

    -- Keymap for local diagnostics
    vim.keymap.set('n', '<leader>d', function()
      require('telescope.builtin').diagnostics({ bufnr = 0 })
    end, { desc = '[D]iagnostics list (Current Buffer)' })
  end,
}
