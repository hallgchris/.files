local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")
local menubar = require("menubar")
local freedesktop = require("freedesktop")

local env = require("config.env")


-- Create a launcher widget and a main menu
myawesomemenu = {
	{ "hotkeys", function() return false, hotkeys_popup.show_help end, menubar.utils.lookup_icon("preferences-desktop-keyboard-shortcuts") },
	{ "manual", env.terminal .. " -e man awesome", menubar.utils.lookup_icon("system-help") },
	{ "edit config", env.gui_editor .. " " .. awesome.conffile,  menubar.utils.lookup_icon("accessories-text-editor") },
	{ "restart", awesome.restart, menubar.utils.lookup_icon("system-restart") }
}
myexitmenu = {
	{ "log out", function() awesome.quit() end, menubar.utils.lookup_icon("system-log-out") },
	{ "suspend", "systemctl suspend", menubar.utils.lookup_icon("system-suspend") },
	{ "hibernate", "systemctl hibernate", menubar.utils.lookup_icon("system-suspend-hibernate") },
	{ "reboot", "systemctl reboot", menubar.utils.lookup_icon("system-reboot") },
	{ "shutdown", "poweroff", menubar.utils.lookup_icon("system-shutdown") }
}
mymainmenu = freedesktop.menu.build({
	icon_size = 32,
	before = {
		{ "Terminal", env.terminal, menubar.utils.lookup_icon("utilities-terminal") },
		{ "Browser", env.browser, menubar.utils.lookup_icon("internet-web-browser") },
		{ "Files", env.filemanager, menubar.utils.lookup_icon("system-file-manager") },
		-- other triads can be put here
	},
	after = {
		{ "Awesome", myawesomemenu, "/usr/share/awesome/icons/awesome32.png" },
		{ "Exit", myexitmenu, menubar.utils.lookup_icon("system-shutdown") },
		-- other triads can be put here
	}
})
mylauncher = awful.widget.launcher({
	image = beautiful.sidebar_icon,
	menu = mymainmenu
})
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

