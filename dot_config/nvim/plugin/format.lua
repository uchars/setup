local ok, fmt = pcall(require, "conform")
if not ok then
	return
end

fmt.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		rust = { "rustfmt" },
		go = { "gofmt" },
		python = { "autopep8" },
		markdown = { "prettierd" },
		java = { "google-java-format" },
	},
})

vim.keymap.set("n", "<leader>fm", function()
	fmt.format()
end)
