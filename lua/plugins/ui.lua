return {
	-- Icons (also stands in for nvim-web-devicons)
	{
		"nvim-mini/mini.icons",
		lazy = true,
		opts = {},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-mini/mini.icons" },
		init = function()
			vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
				callback = function()
					vim.schedule(function() require("lualine").refresh() end)
				end,
			})
		end,
		opts = function()
			local function root_name()
				local root = vim.fs.root(
					0,
					{ ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }
				)
				if not root or root == vim.uv.cwd() then
					return ""
				end
				return vim.fs.basename(root)
			end

			local function recording()
				local reg = vim.fn.reg_recording()
				return reg ~= "" and ("recording @" .. reg) or ""
			end

			return {
				options = {
					theme = "auto",
					globalstatus = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {
						{ root_name },
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{ "filename", path = 1, symbols = { modified = "[+]" } },
					},
					lualine_x = {
						{ recording, color = "DiagnosticWarn" },
						"diagnostics",
						"diff",
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			}
		end,
	},

	-- Window labels
	{
		"b0o/incline.nvim",
		event = "VeryLazy",
		opts = {
			window = {
				padding = 0,
				margin = { horizontal = 0, vertical = 0 },
				placement = { horizontal = "right", vertical = "top" },
			},
			hide = { cursorline = true },
			render = function(props)
				local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				if name == "" then
					name = "[No Name]"
				end
				local icon, hl = require("mini.icons").get("file", name)
				local modified = vim.bo[props.buf].modified
				return {
					" ",
					{ icon, group = hl },
					" ",
					{ name, gui = modified and "bold,italic" or "bold" },
					modified and " [+] " or " ",
				}
			end,
		},
	},
}
