return {
	"folke/snacks.nvim",
	opts = {
		scroll = {
			enabled = false, -- Disable scrolling animations
		},
		context = {
			enabled = true,
			menu = {
				enabled = true,
				items = {
					["sapw"] = {
						name = "SAPW",
						action = function()
							vim.cmd("normal! ggVGp:w")
						end,
						desc = "Select all, paste, write",
					},
				},
			},
		},
	},
}