return {-- tpope/vim-commentary
	"numToStr/Comment.nvim",
	event = "BufReadPost",
	dependencies = {
		--[[ "JoosepAlviste/nvim-ts-context-commentstring", ]]
	},
	config = function()
		require("Comment").setup({
			padding = true,
			sticky = true,
			toggler = {
				line = "<C-_>",
				block = "<C-_>",
				--[[ line = "gcc",
				block = "gbc", ]]
			},
			opleader = {
				line = "<C-_>",
				block = "<C-_>",
				--[[ line = "gc",
				block = "gb", ]]
			},
			mappings = {
				basic = true,
				extra = true,
				extended = false,
			},
			--[[ pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(), ]]
		})
	end,
    --[[ keys = {
      { "<C-_>", "<Plug>CommentaryLine", mode = "n", desc = "Comment line" },
      { "<C-_>", "<Plug>Commentary", mode = "v", desc = "Comment selection" },
    }, ]]
}
