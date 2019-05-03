--						   ████
--						  ▒▒███
--	 ████████	██████	   ▒███  █████ ████  ██████
--	▒▒███▒▒███ ███▒▒███    ▒███ ▒▒███ ▒███	▒▒▒▒▒███
--	 ▒███ ▒▒▒ ▒███ ▒▒▒	   ▒███  ▒███ ▒███	 ███████
--	 ▒███	  ▒███	███    ▒███  ▒███ ▒███	███▒▒███
--	 █████	  ▒▒██████	██ █████ ▒▒████████▒▒████████
--	▒▒▒▒▒	   ▒▒▒▒▒▒  ▒▒ ▒▒▒▒▒   ▒▒▒▒▒▒▒▒	▒▒▒▒▒▒▒▒



-- Theme handling library
local beautiful = require("beautiful")
local theme
if os.getenv("theme") == "light" then
	theme = require("themes.whiteout.theme")
else
	theme = require("themes.blackout.theme")
end
beautiful.init(theme)

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Cleanup (see script for deatails)
awful.spawn.with_shell("~/.config/awesome/awesome-cleanup.sh")

-- Initialise things
local helpers = require("helpers")
local keys = require("config.keys")
local titlebars = require("config.titlebars")
--local sidebar = require("config.sidebar")
local exit_screen = require("config.exit_screen")


require("config.errors")

local env = require("config.env")

require("config.layout")

require("config.menu")

local wibar = require("config.wibar")
wibar:init(env)

require("config.rules")

require("config.signals")

-- Apply shapes
--beautiful.notification_shape = helpers.rrect(beautiful.notification_border_radius * 2)
--beautiful.snap_shape = helpers.rrect(beautiful.border_radius * 2)
--beautiful.taglist_shape = helpers.rrect(beautiful.taglist_item_roundness)

awful.spawn.with_shell("~/.config/awesome/autorun.sh")

