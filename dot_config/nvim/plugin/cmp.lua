local ok_cmp, cmp = pcall(require, "cmp")

if not ok_cmp then
	return
end

local cmp_icons = {
	Namespace = "",
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "ﰠ",
	Variable = "",
	Class = "ﴯ",
	Interface = "",
	Module = "",
	Property = "ﰠ",
	Unit = "塞",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "פּ",
	Event = "",
	Operator = "",
	TypeParameter = "",
	Table = "",
	Object = "",
	Tag = "",
	Array = "[]",
	Boolean = "",
	Number = "",
	Null = "ﳠ",
	String = "",
	Calendar = "",
	Watch = "",
	Package = "",
	Copilot = "",
}

cmp.setup({
	window = {
		documentation = cmp.config.window.bordered(),
		completion = cmp.config.window.bordered({}),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
	},
	formatting = {
		format = function(_, item)
			local icon = cmp_icons[item.kind] or ""
			if string.len(item.abbr) > 50 then
				item.abbr = string.sub(item.abbr, 1, 50) .. " ..."
			end

			icon = " " .. icon .. " " .. item.kind .. " "
			item.menu = cmp_icons.text
			item.kind = icon

			return item
		end,
		fields = { "abbr", "kind", "menu" },
		expandable_indicator = true,
	},
})

-- cmdline search ('/', '?') wildmenu completion
cmp.setup.cmdline("/", {
	view = {
		entries = { name = "wildmenu", separator = "|" },
		docs = {
			auto_open = true,
		},
	},
})
