require("nilsfuncs")

-- [[ Basics ]]
vim.g.mapleader = " "
vim.o.hlsearch = false
vim.o.scrolloff = 8
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.mouse = "a"
vim.o.breakindent = true
vim.opt.guicursor = ""
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.o.undofile = true
vim.o.swapfile = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = "yes"
vim.o.updatetime = 50
vim.o.completeopt = "menuone,noselect"
vim.o.termguicolors = true

-- [[ Keymaps ]]
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>")
vim.keymap.set("i", "<C-s>", "<cmd>w<cr>")
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>)")
vim.api.nvim_set_keymap("t", "<C-r>", "<C-r>", { noremap = false, silent = true })
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", ";a", "aä<ESC>")
vim.keymap.set("n", ";o", "aö<ESC>")
vim.keymap.set("n", ";u", "aü<ESC>")
vim.keymap.set("n", "<C-b>", "<cmd>:Ex<cr>")
vim.api.nvim_set_keymap("n", "<C-f>", [[:lua InpGrepQf()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gr", [[:lua GrepCword()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k><C-o>", [[:lua HeaderSourceToggle()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-p>", [[:lua FindFile()<CR>]], { noremap = true, silent = true })

-- [[ Autocmd ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
local format_group = vim.api.nvim_create_augroup("FormatGroup", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = format_group,
	pattern = "*",
	command = "%s/\\s\\+$//e",
})
vim.cmd([[autocmd FileType * setlocal formatoptions-=cro]])
vim.cmd([[autocmd BufNewFile,BufRead Dockerfile* set filetype=Dockerfile]])
vim.api.nvim_create_user_command("W", function()
	vim.cmd("w")
end, { nargs = 0 })

if not vim.fn.system("nixos-version") ~= "" and not os.getenv("NVIM_MINIMAL") then
	require("bootstrap")
end

require("statusline")

vim.api.nvim_create_user_command("Minimal", function()
	vim.api.nvim_set_keymap("n", "<C-f>", [[:lua InpGrepQf()<CR>]], { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "gr", [[:lua GrepCword()<CR>]], { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<C-k><C-o>", [[:lua HeaderSourceToggle()<CR>]], { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<C-p>", [[:lua FindFile()<CR>]], { noremap = true, silent = true })
end, { nargs = 0 })

vim.cmd([[colorscheme solarized8]])
