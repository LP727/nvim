return {
	"rcarriga/nvim-dap-ui",

	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")

		-- to have nvim-dap open kitty on debug
		dap.defaults.fallback.external_terminal = {
			command = "kitty",
			args = {},
		}

		local cargo = require("utils.cargo_dap")

		dap.listeners.on_config["cargo_program"] = function(config)
			if config.program == "${cargo:program}" then
				config = vim.deepcopy(config)
				config.program = cargo.program()
			end
			return config
		end

		dap.configurations.rust = dap.configurations.rust or {}
		table.insert(dap.configurations.rust, {
			name = "Cargo: build and launch",
			type = "codelldb",
			request = "launch",
			program = cargo.program,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			terminal = "external",
		})

		-- Plain-Unicode icons so no Nerd Font is needed
		-- TODO: Setup NerFont and add in README
		dapui.setup({
			icons = { expanded = "v", collapsed = ">", current_frame = ">" },
			controls = {
				icons = {
					pause = "||",
					play = "▶",
					step_into = "↓",
					step_over = "→",
					step_out = "↑",
					step_back = "←",
					run_last = "↻",
					terminate = "■",
					disconnect = "⏏",
				},
			},
		})

		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk" })

		-- codelldb adapter (installed by Mason), also reachable as "lldb"
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
				args = { "--port", "${port}" },
			},
		}
		dap.adapters.lldb = dap.adapters.codelldb
		dap.listeners.before.attach.dapui_config = function() dapui.open() end
		dap.listeners.before.launch.dapui_config = function() dapui.open() end
		dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
		dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
	end,
	keys = {
		{
			"<leader>dg",
			function() require("dap").toggle_breakpoint() end,
			desc = "Toggle breakpoint",
		},
		{
			"<leader>dc",
			function() require("dap").continue() end,
			desc = "Continue or start",
		},
		{
			"<leader>dO",
			function() require("dap").step_over() end,
			desc = "Step over",
		},
		{
			"<leader>di",
			function() require("dap").step_into() end,
			desc = "Step into",
		},
		{
			"<leader>do",
			function() require("dap").step_out() end,
			desc = "Step out",
		},
		{
			"<leader>dt",
			function() require("dap").terminate() end,
			desc = "Stop",
		},
		{
			"<leader>du",
			function() require("dapui").toggle() end,
			desc = "Toggle dap-ui",
		},
	},
}
