local M = {}

local SEP_L = vim.fn.nr2char(0xE0BA) -- ◢
local SEP_R = vim.fn.nr2char(0xE0B8) -- ◣

local function hl_attr(name, attr)
	local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
	return hl[attr]
end

function M.setup_highlights()
	local act_bg = hl_attr("TabLineSel", "bg") or hl_attr("Visual", "bg")
	local act_fg = hl_attr("TabLineSel", "fg") or hl_attr("Normal", "fg")
	local ina_bg = hl_attr("TabLine", "bg") or hl_attr("CursorLine", "bg")
	local ina_fg = hl_attr("TabLine", "fg") or hl_attr("Comment", "fg")

	local set = vim.api.nvim_set_hl
	set(0, "MyTabActive", { fg = act_fg, bg = act_bg, bold = true })
	set(0, "MyTabActiveSep", { fg = act_bg, bg = "NONE" })
	set(0, "MyTabInactive", { fg = ina_fg, bg = ina_bg })
	set(0, "MyTabInactiveSep", { fg = ina_bg, bg = "NONE" })
	set(0, "MyTabFill", { bg = "NONE" })
end

-- Names over 20 chars are cut to 17 plus an ellipsis
local function truncate(s, from_left)
	if vim.fn.strchars(s) <= 20 then
		return s
	end
	if from_left then
		return "…" .. vim.fn.strcharpart(s, vim.fn.strchars(s) - 17)
	end
	return vim.fn.strcharpart(s, 0, 17) .. "…"
end

local function label(tabnr)
	local buflist = vim.fn.tabpagebuflist(tabnr)
	local buf = buflist[vim.fn.tabpagewinnr(tabnr)]
	local name = vim.api.nvim_buf_get_name(buf)

	local modified = false
	for _, b in ipairs(buflist) do
		if vim.bo[b].modified then
			modified = true
		end
	end

	local icon, text = "", ""
	if vim.bo[buf].buftype == "terminal" then
		text = "[Terminal]"
	elseif name:match("^oil://") then
		local dir = (name:gsub("^oil://", ""))
		text = truncate(vim.fn.fnamemodify(dir, ":~:h"), true)
	elseif name == "" then
		text = "[No Name]"
	else
		local fname = vim.fn.fnamemodify(name, ":t")
		local ok, mini = pcall(require, "mini.icons")
		if ok then
			icon = (mini.get("file", fname)) .. " "
		end
		text = truncate(fname)
	end

	text = text:gsub("%%", "%%%%") -- escape % for the tabline format
	return (modified and "[+]" or "") .. icon .. text
end

function M.render()
	local current = vim.fn.tabpagenr()
	local out = {}
	for i = 1, vim.fn.tabpagenr("$") do
		local kind = i == current and "Active" or "Inactive"
		out[#out + 1] = table.concat({
			"%" .. i .. "T",
			"%#MyTab" .. kind .. "Sep#" .. SEP_L,
			"%#MyTab" .. kind .. "#   " .. label(i) .. "   ",
			"%#MyTab" .. kind .. "Sep#" .. SEP_R,
		})
	end
	out[#out + 1] = "%#MyTabFill#%T"
	return table.concat(out)
end

function M.setup()
	vim.o.showtabline = 1 -- only show with 2+ tabs
	vim.o.tabline = "%!v:lua.require'config.tabline'.render()"
	M.setup_highlights()
	vim.api.nvim_create_autocmd("ColorScheme", { callback = M.setup_highlights })
	vim.api.nvim_create_autocmd("BufModifiedSet", {
		callback = function() vim.cmd.redrawtabline() end,
	})
end

return M
