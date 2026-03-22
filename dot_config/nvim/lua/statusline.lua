local function FallbackStatusline()
  vim.opt.statusline = "%f%m%= %{&fileencoding?&fileencoding:&encoding}[%{&fileformat}]%y %3p%% %4l:%3c"
end

local function Statusline()
  vim.opt.statusline =
  "[%{FugitiveHead()}] %f%m%= %{&fileencoding?&fileencoding:&encoding}[%{&fileformat}]%y %3p%% %4l:%3c"
end

if vim.fn.exists(":Git") > 0 then
  Statusline()
else
  FallbackStatusline()
end
