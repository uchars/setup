local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local fd = os.getenv("HOME") .. "/.local/bin/fd/fd"
local rootPath = os.getenv("HOME") .. "/Documents"
local dotfiles = os.getenv("HOME") .. "/.files"
local work = os.getenv("HOME") .. "/work"
local src = os.getenv("HOME") .. "/src"
local tmp = "/tmp/scratch"

M.toggle = function(window, pane)
  local projects = {
    { label = dotfiles, id = ".files" },
  }

  local success, stdout, stderr = wezterm.run_child_process({
    fd,
    "-HI",
    "-td",
    ".",
    "-E",
    ".git",
    "--max-depth=5",
    rootPath,
    dotfiles,
    work,
    src,
    tmp,
    notes,
  })

  if not success then
    wezterm.log_error("Failed to run fd: " .. stderr)
    return
  end

  for line in stdout:gmatch("([^\n]*)\n?") do
    local project = line:gsub("/.git/$", "")
    local label = project
    local id = project:gsub(os.getenv("HOME"), "~")
    wezterm.log_info("inserting id='" .. tostring(id) .. "'")
    table.insert(projects, { label = tostring(label), id = tostring(id) })
  end

  window:perform_action(
    act.InputSelector({
      action = wezterm.action_callback(function(win, _, id, label)
        if not id and not label then
          wezterm.log_info("Cancelled")
        else
          wezterm.log_info("Selected " .. label)
          win:perform_action(act.SwitchToWorkspace({ name = id, spawn = { cwd = label } }), pane)
        end
      end),
      fuzzy = true,
      fuzzy_description = "> ",
      title = "Select project",
      choices = projects,
    }),
    pane
  )
end

return M
