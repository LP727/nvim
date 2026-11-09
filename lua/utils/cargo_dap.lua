local M = {}

function M.program()
	local out = vim.fn.systemlist("cargo build --message-format=json 2>/dev/null")
	if vim.v.shell_error ~= 0 then
		vim.notify("cargo build failed", vim.log.levels.ERROR)
		return nil
	end
	local exe
	for _, line in ipairs(out) do
		local ok, msg = pcall(vim.json.decode, line)
		if
			ok
			and type(msg) == "table"
			and msg.reason == "compiler-artifact"
			and msg.executable
			and msg.executable ~= vim.NIL
		then
			exe = msg.executable
		end
	end
	return exe
end

return M
