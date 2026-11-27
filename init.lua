vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.env.CC = "clang"

-- to make rust-analyzer work on new files
-- this uses cpu, 1 watch is about 1 KB of ram, 1 watcher per directory, watchers are spawned by rust-analyzer upon opening a rust file.
-- The watches cover the Cargo project that the .rs file is part of. So the watcher server setting CAN increase CPU usage.
vim.g.rustaceanvim = {
	dap = { autoload_configurations = false },
	server = {
		default_settings = {
			["rust-analyzer"] = { files = { watcher = "server" } },
		},
	},
}

-- to find the .nvim.lua on a dir change and enable debugging
vim.api.nvim_create_autocmd("DirChanged", {
	callback = function()
		local code = vim.secure.read(vim.fn.getcwd() .. "/.nvim.lua")
		if code then
			assert(loadstring(code))()
		end
	end,
})

-- to silence the pynvim warnings in checkhealth
vim.g.loaded_python3_provider = 0

-- To ensure the rust inlay are enabled, without this line it fails sometimes
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args) vim.lsp.inlay_hint.enable(true, { bufnr = args.buf }) end,
})

-- to read local project launch for debug
vim.o.exrc = true

require("config.lazy")
require("config.tabline").setup()
