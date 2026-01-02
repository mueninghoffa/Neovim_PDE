return {
  {
    'wfxr/minimap.vim',
    lazy = false, -- Needs to start up early to attach to windows
    init = function()
      -- Configuration options
      vim.g.minimap_width = 10
      vim.g.minimap_auto_start = 1
      vim.g.minimap_auto_start_win_enter = 1
      -- Use block characters for smoother look (optional, comment out for real text)
      -- vim.g.minimap_block_buftypes = {'nofile', 'terminal'} 
    end,
    config = function()
      -- Check if the binary exists, if not, warn the user
      if vim.fn.executable("code-minimap") == 0 then
        vim.notify("Minimap: 'code-minimap' binary not found. Run 'cargo install code-minimap'", vim.log.levels.WARN)
      end
    end
  },
}
