return {
	"neovim/nvim-lspconfig",
	config = function()
		vim.lsp.enable("lua_ls")
		-- below enables libc include in C builds
		vim.lsp.config("clangd", {
			cmd = {
				"clangd",
				"--background-index",
				"--query-driver=/opt/arm-gnu-toolchain*/bin/arm-none-eabi-*",
			},
		})
		vim.lsp.enable("clangd")
	end,
}
