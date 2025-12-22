return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require('gitsigns').setup({
            signs = {
                add          = { text = '│' },
                change       = { text = '│' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
            },
            current_line_blame = true, -- Toggle this to see "Blame" text next to the cursor!
            current_line_blame_opts = {
                delay = 500,
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                -- Keymaps for navigation
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation (Jump between changes)
                map('n', ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, {expr=true})

                map('n', '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, {expr=true})

                -- Actions
                map('n', '<leader>gp', gs.preview_hunk, { desc = 'Git: Preview Hunk' })
                map('n', '<leader>gb', gs.toggle_current_line_blame, { desc = 'Git: Toggle Blame' })
            end
        })
    end
}