return {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    branch = "regexp", -- Use the regexp branch (better for Conda)
    config = function()
        require("venv-selector").setup({
            settings = {
                search = {
                    -- This finds conda envs in standard locations
                    anaconda_envs = {
                        command = "fd python$ C:\\Users\\YOUR_USERNAME\\miniconda3\\envs --full-path --color never -E /bin",
                        type = "anaconda" 
                    }
                    -- Note: Adjust the path above to match where your miniconda envs actually live!
                }
            }
        })
    end,
    keys = {
        { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    },
}