vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.env.CC = "clang"

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args) vim.lsp.inlay_hint.enable(true, { bufnr = args.buf }) end,
})

require("config.lazy")
