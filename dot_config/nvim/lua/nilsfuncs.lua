function GrepWord(word)
  local search_cmd = string.format("vimgrep /%s/gj **", word)
  local ok, _ = pcall(vim.cmd, search_cmd)
  if not ok then
    return
  end

  local qflist = vim.fn.getqflist()
  if next(qflist) then
    vim.cmd("copen")
  end
end

function GrepCword()
  local word = vim.fn.expand("<cword>")
  GrepWord(word)
end

function InpGrepQf()
  local input = vim.fn.input("Search for: ")
  if input == "" then
    return
  end
  GrepWord(input)
end

local function file_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "file"
end

function HeaderSourceToggle()
  local c_headers = { "h", "hh", "hpp" }
  local c_sources = { "c", "cpp", "cc" }
  local c_map = {}
  for _, key in ipairs(c_headers) do
    c_map[key] = c_sources
  end
  for _, key in ipairs(c_sources) do
    c_map[key] = c_headers
  end

  local fname = vim.fn.expand("%:r")
  local fext = vim.fn.expand("%:e")
  if c_map[fext] ~= nil then
    for _, ext in ipairs(c_map[fext]) do
      local fpath = fname .. "." .. ext
      if file_exists(fpath) then
        vim.cmd(":e " .. fpath)
      end
    end
  end
end

function FindFile()
  local input = vim.fn.input("Search file: ")
  if input == "" then
    return
  end
  local files = vim.fn.globpath('.', '**/*' .. input .. '*', true, true)
  if #files == 0 then
    return
  end
  local qflist = {}
  for _, file in ipairs(files) do
    table.insert(qflist, {filename = file})
  end
  vim.fn.setqflist(qflist, "r")
  vim.cmd("copen")
end
