local awful = require("awful")
local beautiful = require("beautiful")
local keys = require("config.keys")


-- Get screen geometry
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
	  properties = { border_width = beautiful.border_width,
					 border_color = beautiful.border_normal,
					 focus = awful.client.focus.filter,
					 raise = true,
					 keys = keys.clientkeys,
					 buttons = keys.clientbuttons,
					 size_hints_honor = false, -- Remove gaps between terminals
					 screen = awful.screen.preferred,
					 callback = awful.client.setslave,
					 placement = awful.placement.no_overlap+awful.placement.no_offscreen
	 }
	},

	-- Floating clients.
	{ rule_any = {
		instance = {
		  "DTA",  -- Firefox addon DownThemAll.
		  "copyq",	-- Includes session name in class.
		},
		class = {
		  "Arandr",
		  "Gpick",
		  "Kruler",
		  "MessageWin",  -- kalarm.
		  "Sxiv",
		  "Wpa_gui",
		  "pinentry",
		  "veromix",
		  "xtightvncviewer"},

		name = {
		  "Event Tester",  -- xev.
		},
		role = {
		  "AlarmWindow",  -- Thunderbird's calendar.
		  "pop-up",		  -- e.g. Google Chrome's (detached) Developer Tools.
		}
	  }, properties = { floating = true }},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = {type = { "normal", "dialog" } },
	  properties = { titlebars_enabled = true }
	},

	-- Titlebars OFF (explicitly)
	-- Titlebars of these clients will be hidden regardless of the theme setting
	{ rule_any = {
		class = {
		  "qutebrowser",
		  -- "feh",
		  -- "Gimp",
		  "Sublime_text",
		  --"discord",
		  --"TelegramDesktop",
		  "Firefox",
		  "Steam",
		  "Chromium-browser",
		  },
	  }, properties = { titlebars_enabled = false, disable_toggle_all_titlebars = true},
	  --callback = function (c)
	  --  if not beautiful.titlebars_imitate_borders then
	  --      awful.titlebar.hide(c, beautiful.titlebar_position)
	  --  end
	  --end
	},

	-- Titlebars ON (explicitly)
	-- Titlebars of these clients will be shown regardless of the theme setting
	{ rule_any = {
		class = {
		  --"???",
		  },
		name = {
		  "File Upload",
		  "Open File",
		  "Select a filename",
		  "Enter name of file to save to…",
		  "Library"
		},
	  }, properties = {},
	  callback = function (c)
		awful.titlebar.show(c, beautiful.titlebar_position)
	  end
	},

	-- Fixed terminal geometry
	{ rule_any = {
		class = {
		  "Termite",
		  "mpvtube",
		  "kitty",
		  "st-256color",
		  "st",
		  "URxvt",
		  "Alacritty",
		  },
	  }, properties = { width = screen_width * 0.45, height = screen_height * 0.5 }
	},

	-- Steam guard
	{ rule = { name = "Steam Guard - Computer Authorization Required" },
	  properties = { floating = true },
	  callback = function (c)
		gears.timer.delayed_call(function()
			awful.placement.centered(c,{honor_workarea=true})
		end)
	  end
	},
	
}
