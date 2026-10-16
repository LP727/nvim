return {
	"rcarriga/nvim-dap-ui",

	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		require("dapui").setup()
		local dap, dapui = require("dap"), require("dapui")
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
	end,
	keys = {
		{
			"<leader>dg",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle breakpoint",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Continue or start",
		},
		{
			"<leader>dO",
			function()
				require("dap").step_over()
			end,
			desc = "Step over",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Step into",
		},
		{
			"<leader>do",
			function()
				require("dap").step_out()
			end,
			desc = "Step out",
		},
		{
			"<leader>dt",
			function()
				require("dap").terminate()
			end,
			desc = "Stop",
		},
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "Toggle dap-ui",
		},
	},
}
