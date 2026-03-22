local ok, _ = pcall(require, "harpoon")
if not ok then
  return
end

vim.keymap.set("n", "<leader>ha", require("harpoon.mark").add_file)
vim.keymap.set("n", "<leader>hh", require("harpoon.ui").toggle_quick_menu)
vim.keymap.set("n", "<space>1", function()
  require("harpoon.ui").nav_file(1)
end)
vim.keymap.set("n", "<space>2", function()
  require("harpoon.ui").nav_file(2)
end)
vim.keymap.set("n", "<space>3", function()
  require("harpoon.ui").nav_file(3)
end)
vim.keymap.set("n", "<space>4", function()
  require("harpoon.ui").nav_file(4)
end)
vim.keymap.set("n", "<space>5", function()
  require("harpoon.ui").nav_file(5)
end)
