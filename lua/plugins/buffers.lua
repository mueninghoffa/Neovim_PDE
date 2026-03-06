return {
	"axkirillov/hbac.nvim",
	event = "VeryLazy",
	opts = {
		threshold = 10, -- Close oldest buffer when you have more than 10
		kill_old_dimmed = true, -- Automatically close buffers that aren't visible
		-- You can "pin" buffers you never want closed (like a scratchpad)
		-- pinned_buffer_icon = "📌",
	},
	config = function(_, opts)
		require("hbac").setup(opts)
	end,
}
