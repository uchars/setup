local wezterm = require("wezterm")
local sessionizer = require("sessionizer")
local config = wezterm.config_builder()
local launch_menu = {}

config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_style = {}
config.audible_bell = "Disabled"
config.window_close_confirmation = "AlwaysPrompt"
config.default_workspace = "home"
config.scrollback_lines = 3000
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "powershell.exe", "-NoLogo" }
  launch_menu = {
    {
      label = "PowerShell",
      args = { "powershell.exe", "-NoLogo" },
    },
    {
      label = "ssh rme@10.42.42.182",
      args = { "ssh", "rme@10.42.42.182" },
    },
  }

  for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files")) do
    local year = vsvers:gsub("Microsoft Visual Studio/", "")
    table.insert(launch_menu, {
      label = "x64 Native Tools VS " .. year .. " Community",
      args = {
        "cmd.exe",
        "/k",
        "C:\\Program Files\\Microsoft Visual Studio\\"
        .. year
        .. "\\Community\\VC\\Auxiliary\\Build\\vcvars64.bat",
      },
    })
    table.insert(launch_menu, {
      label = "x64 Native Tools VS " .. year .. " Professional",
      args = {
        "cmd.exe",
        "/k",
        "C:\\Program Files\\Microsoft Visual Studio\\"
        .. year
        .. "\\Professional\\VC\\Auxiliary\\Build\\vcvars64.bat",
      },
    })
  end
end

config.launch_menu = launch_menu

config.inactive_pane_hsb = { saturation = 0.5, brightness = 0.5 }
config.disable_default_key_bindings = true
config.leader = { key = "y", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
  {
    key = "L",
    mods = "LEADER",
    action = wezterm.action.ShowLauncherArgs({ flags = "LAUNCH_MENU_ITEMS" }),
  },
  { key = "a",          mods = "LEADER|CTRL", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
  { key = "phys:Space", mods = "ALT",         action = wezterm.action.ActivateCommandPalette },
  { key = "c",          mods = "LEADER",      action = wezterm.action.ActivateCopyMode },
  { key = "L",          mods = "LEADER",      action = wezterm.action.ShowDebugOverlay },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "v",
    mods = "LEADER",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "q", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
  { key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
  {
    key = "v",
    mods = "CTRL",
    action = wezterm.action.PasteFrom("Clipboard"),
  },
  { key = "t", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
  { key = "[", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
  { key = "]", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
  { key = "n", mods = "LEADER", action = wezterm.action.ShowTabNavigator },
  { key = "m", mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
  {
    key = "r",
    mods = "LEADER",
    action = wezterm.action.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
  },
  {
    key = "e",
    mods = "LEADER",
    action = wezterm.action.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "Renaming Tab Title...:" },
      }),
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  { key = "w", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
  {
    key = "W",
    mods = "LEADER",
    action = wezterm.action.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "Enter name for new workspace" },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            wezterm.action.SwitchToWorkspace({
              name = line,
            }),
            pane
          )
        end
      end),
    }),
  },
  { key = "f", mods = "LEADER", action = wezterm.action_callback(sessionizer.toggle) },
}

config.key_tables = {
  resize_pane = {
    { key = "h",      action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
    { key = "j",      action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
    { key = "k",      action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
    { key = "l",      action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  },
  move_tab = {
    { key = "h",      action = wezterm.action.MoveTabRelative(-1) },
    { key = "j",      action = wezterm.action.MoveTabRelative(-1) },
    { key = "k",      action = wezterm.action.MoveTabRelative(1) },
    { key = "l",      action = wezterm.action.MoveTabRelative(1) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  },
}

for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = wezterm.action.ActivateTab(i - 1),
  })
  table.insert(config.keys, {
    key = "F" .. tostring(i),
    action = wezterm.action.ActivateTab(i - 1),
  })
end

wezterm.on("update-right-status", function(window, _)
  window:set_right_status(window:active_workspace())
end)

return config
