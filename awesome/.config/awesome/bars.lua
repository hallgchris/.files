local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local helpers = require("helpers")

local icon_taglist = require("widgets.icon_taglist")
local desktop_control = require("widgets.desktop_control")

start_widget = wibox.widget.imagebox(beautiful.sidebar_icon)
start_widget:buttons(gears.table.join(
	awful.button({ }, 1, function()
		mymainmenu:toggle()
	end)
))

-- Create item separator
textseparator = wibox.widget.textbox()
textseparator.text = beautiful.separator_text
textseparator.font = "hermit nerd font bold 14"
textseparator.markup = helpers.colorize_text(textseparator.text, beautiful.separator_fg)

-- Create padding
pad = wibox.widget.textbox(" ")

awful.screen.connect_for_each_screen(function(s)
	-- Create a system tray widget
	s.systray = wibox.widget.systray()

	-- Wibar detached - Method: Transparent useless bar
	-- Requires compositor
	if beautiful.wibar_detached then
        s.useless_wibar = awful.wibar({
			position = beautiful.wibar_position,
			screen = s,
			height = beautiful.screen_margin * 2,
			opacity = 0
		})
	end

	-- Create the wibox
    s.mywibox = awful.wibar({
		position = beautiful.wibar_position,
		screen = s,
		width = beautiful.wibar_width,
		height = beautiful.wibar_height,
		shape = helpers.rrect(beautiful.wibar_border_radius)
	})

    -- Wibar items
    -- Add or remove widgets here
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            pad,
            start_widget,
        },
        { -- Middle widgets
            layout = wibox.layout.fixed.horizontal,
            textseparator,
            icon_taglist,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            textseparator,
            desktop_control,
            pad,
        },
	}
end)

