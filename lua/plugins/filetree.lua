return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- Disable netrw
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            view = { width = 30 },
            renderer = {
                group_empty = true,
                -- This section configures the icons
                icons = {
                    git_placement = "after", -- Show the icon after the filename
                    glyphs = {
                        git = {
                            unstaged = "M",
                            staged = "S",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "U",
                            deleted = "",
                            ignored = "◌",
                        },
                    },
                },
            },
            -- This section enables the functionality
            git = {
                enable = true,
                ignore = false, -- Set to true if you want to hide .gitignore files
                timeout = 500,
            },
        })
        
        vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Tree" })
    end
}