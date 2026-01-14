local ok, conform = pcall(require, "conform")

if not ok then
	return
end

local config = {
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff" },
		rust = { "rustfmt" },
	},
	format_on_save = {
		timeout_ms = 500,
	},
}
conform.setup(config)

local wk = require("which-key")
wk.add({ "<leader>w", "<cmd>noau w<CR>", desc = "Save without formatting" })
