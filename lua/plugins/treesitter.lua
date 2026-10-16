return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({ "rust", "toml", "regex" })

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "rust", "toml", "lua", "markdown" },
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
