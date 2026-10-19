return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"codelldb",
				"stylua",
				"taplo",
				"shfmt",
				"black",
				"isort",
				"prettier",
				"prettierd",
				"lua-language-server",
			},
		},
	},
}
