return {
	"j-hui/fidget.nvim",
	opts = {
		-- Options related to logging
		logger = {
			enable = true, -- Whether to enable file logging
			level = vim.log.levels.WARN, -- Minimum logging level
			max_size = 20000, -- Maximum log file size, in KB
			float_precision = 0.01, -- Limit the number of decimals displayed for floats
			-- Where Fidget writes its logs to
			path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
		},
	},
}
