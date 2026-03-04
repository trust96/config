local wezterm = require("wezterm")

local config = wezterm.config_builder()
local action = wezterm.action
config.color_scheme = "AdventureTime"
config.font_size = 25.0
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 3000 }
config.keys = {
	{ key = "h", mods = "ALT", action = action.ActivateTabRelative(-1) },
	{ key = "l", mods = "ALT", action = action.ActivateTabRelative(1) },
	{
		key = "n",
		mods = "ALT",
		action = action.SpawnCommandInNewTab({}),
	},
	{ key = "UpArrow", mods = "CTRL|SHIFT", action = action.ScrollByLine(-1) },
	{ key = "DownArrow", mods = "CTRL|SHIFT", action = action.ScrollByLine(1) },
	{ key = "q", mods = "LEADER", action = action.ActivateKeyTable({ name = "quit", timeout_milliseconds = 3000 }) },
}
config.key_tables = {
	quit = {
		{ key = "p", action = action.CloseCurrentPane({ confirm = false }) },
	},
}
-- and finally, return the configuration to wezterm
return config
