local ok, _ = pcall(require, "mason")
local ok_lsp, mason_lsp = pcall(require, "mason-lspconfig")
local is_nixos = vim.fn.executable("nixos-rebuild")
-- if not ok and not ok_lsp or is_nixos then
-- 	return
-- end


require'nvim-web-devicons'.setup()

local haskell_installed = vim.fn.executable("ghcup") == 1
local py_installed = vim.fn.executable("python") == 1 or vim.fn.executable("python3") == 1
local go_installed = vim.fn.executable("go") == 1
local unzip_installed = vim.fn.executable("unzip") == 1
local cargo_installed = vim.fn.executable("cargo") == 1
local npm_installed = vim.fn.executable("npm") == 1
local is_windows = vim.fn.has("win32") or vim.fn.has("win64")
local ocaml_installed = vim.fn.executable("opam") == 1

local servers = {
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

if unzip_installed and is_windows then
	servers.zls = {}
end

if not is_windows then
	servers.zls = {}
end

if unzip_installed or is_windows then
	servers.clangd = {}
	servers.jdtls = {}
end

if cargo_installed then
	servers.rust_analyzer = {}
	if not is_windows then
		servers.nil_ls = {}
	end
end

if go_installed then
	servers.gopls = {}
	servers.sqls = {}
end

if py_installed then
	--servers.cmake = {}
	servers.pylsp = {}
end

if npm_installed then
	servers.dockerls = {}
	servers.tsserver = {}
	servers.bashls = {}
	servers.marksman = {}
	servers.html = { filetypes = { "html", "twig", "hbs" } }
end

if ocaml_installed then
	servers.ocamllsp = {}
end

if haskell_installed then
	servers.hls = {}
end

mason_lsp.setup({
	automatic_installation = false,
	ensure_installed = vim.tbl_keys(servers),
})

local ok_mason_format, format = pcall(require, "mason-conform")
if ok_mason_format then
	format.setup({
		automatic_installation = false,
		ensure_installed = { "stylua", "jq", "prettierd", "clang-format" },
	})
end
