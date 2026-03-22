local ok_gs, gs = pcall(require, "gitsigns")
if not ok_gs then
  return
end

gs.setup()

vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>")
