vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.env.CC = "clang"

-- to silence the pynvim warnings in checkhealth
vim.g.loaded_python3_provider = 0

-- To ensure the rust inlay are enabled, without this line it fails sometimes
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args) vim.lsp.inlay_hint.enable(true, { bufnr = args.buf }) end,
})

require("config.lazy")
