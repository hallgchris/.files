local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local helpers = require("helpers")
local pad = helpers.pad

-- Item configuration

local time = wibox.widget.textclock("%H %M")
time.align = "center"
time.valign = "center"
--time.font = beautiful.sidebar_time_font .. " 50"
time.font = beautiful.sidebar_font .. " 50"

-- local date = wibox.widget.textclock("%A, %B %d")
local date = wibox.widget.textclock("%A, %B %d, %Y")
date.align = "center"
date.valign = "center"
date.font = beautiful.sidebar_font .. " medium 15"

local fancy_date = wibox.widget.textclock("%-j days around the sun")
fancy_date.align = "center"
fancy_date.valign = "center"
fancy_date.font = beautiful.sidebar_font .. " sans 11"

local weather_widget = require("widgets.weather")
local weather_widget_text = weather_widget:get_all_children()[2]
weather_widget_text.font = beautiful.sidebar_font .. " 13"
local weather = wibox.widget {
	pad(0),
	weather_widget,
	pad(0),
	layout = wibox.layout.align.horizontal,
	expand = "none",
}

local playerctl_button_size = 50

local playerctl_toggle_icon = wibox.widget.imagebox(beautiful.playerctl_toggle_icon)
playerctl_toggle_icon.resize = true
playerctl_toggle_icon.forced_width = playerctl_button_size
playerctl_toggle_icon.forced_height = playerctl_button_size
playerctl_toggle_icon:buttons(gears.table.join(
	awful.button({ }, 1, function()
		awful.spawn.with_shell("playerctl play-pause")
	end)
))

local playerctl_prev_icon = wibox.widget.imagebox(beautiful.playerctl_prev_icon)
playerctl_prev_icon.resize = true
playerctl_prev_icon.forced_width = playerctl_button_size
playerctl_prev_icon.forced_height = playerctl_button_size
playerctl_prev_icon:buttons(gears.table.join(
	awful.button({ }, 1, function()
		awful.spawn.with_shell("playerctl previous")
	end)
))

local playerctl_next_icon = wibox.widget.imagebox(beautiful.playerctl_next_icon)
playerctl_next_icon.resize = true
playerctl_next_icon.forced_width = playerctl_button_size
playerctl_next_icon.forced_height = playerctl_button_size
playerctl_next_icon:buttons(gears.table.join(
	awful.button({ }, 1, function()
		awful.spawn.with_shell("playerctl next")
	end)
))

local playerctl_buttons = wibox.widget {
	pad(0),
	{
		playerctl_prev_icon,
		pad(1),
		playerctl_toggle_icon,
		pad(1),
		playerctl_next_icon,
		layout = wibox.layout.fixed.horizontal,
	},
	pad(0),
	expand = "none",
	layout = wibox.layout.align.horizontal,
}

local mpris_song = require("widgets.mpris")
local mpris_widget_children = mpris_song:get_all_children()
local mpris_title = mpris_widget_children[1]
local mpris_artist = mpris_widget_children[2]
mpris_title.font = beautiful.sidebar_font .. " medium 15"
mpris_artist.font = beautiful.sidebar_font .. " sans 11"
mpris_title.forced_height = 25
mpris_artist.forced_height = 22

local volume = require("widgets.volume")
local cpu = require("widgets.cpu")
local temperature = require("widgets.temperature")
local ram = require("widgets.ram")
local battery = require("widgets.battery")
local disk = require("widgets.disk")

local search_icon = wibox.widget.imagebox(beautiful.search_icon)
search_icon.resize = true
search_icon.forced_width = 40
search_icon.forced_height = 40
local search_text = wibox.widget.textbox("Search")
search_text.font = beautiful.sidebar_font .. " 13"

local search = wibox.widget{
	search_icon,
	search_text,
	layout = wibox.layout.fixed.horizontal,
}

search:buttons(gears.table.join(
	awful.button({ }, 1, function()
		awful.spawn.with_shell("rofi -show combi")
	end)
))

local exit_icon = wibox.widget.imagebox(beautiful.poweroff_icon)
exit_icon.resize = true
exit_icon.forced_width = 40
exit_icon.forced_height = 40
local exit_text = wibox.widget.textbox("Exit")
exit_text.font = beautiful.sidebar_font .. " 13"

local exit = wibox.widget {
	exit_icon,
	exit_text,
	layout = wibox.layout.fixed.horizontal,
}

exit:buttons(gears.table.join(
	awful.button({ }, 1, function()
		exit_screen_show()
		sidebar.visible = false
	end)
))

-- Create the sidebar
sidebar = wibox({x = 0, y = 0, visible = false, ontop = true, type = "dock"})

sidebar.bg = beautiful.sidebar_bg or beautiful.wibar_bg or "#111111"
sidebar.fg = beautiful.sidebar_fg or beautiful.wibar_fg or "#FFFFFF"
sidebar.opacity = beautiful.sidebar_opacity or 1
sidebar.height = beautiful.sidebar_height or awful.screen.focused().geometry.height
sidebar.width = beautiful.sidebar_width or 300
sidebar.y = beautiful.sidebar_y or 0
local radius = beautiful.sidebar_border_radius or 0
if beautiful.sidebar_position == "right" then
  sidebar.x = awful.screen.focused().geometry.width - sidebar.width
  sidebar.shape = helpers.prrect(radius, true, false, false, true)
else
  sidebar.x = 0
  sidebar.shape = helpers.prrect(radius, false, true, true, false)
end

sidebar:buttons(gears.table.join(
	-- Middle click - Hide the sidebar
	awful.button({ }, 2, function()
		sidebar.visible = false
	end)
))

-- Hide sidebar when mouse leaves
if beautiful.sidebar_hide_on_mouse_leave then 
	sidebar:connect_signal("mouse::leave", function()
		sidebar.visible = false
	end)
end

if beautiful.sidebar_hide_on_mouse_leave then
	local sidebar_activator = wibox({
		y = 0,
		width = 1,
		height = awful.screen.focused().geometry.height,
		visible = true,
		ontop = false,
		opacity = 0,
		below = true
	})

	sidebar_activator:connect_signal("mouse::enter", function()
		sidebar.visible = true
	end)

	if beautiful.sidebar_position == "right" then
		sidebar_activator.x = awful.screen.focused().geometry.width - sidebar_activator.width
	else
		sidebar_activator.x = 0
	end

	sidebar_activator:buttons(
		gears.table.join(
			awful.button({ }, 2, function()
				sidebar.visible = not sidebar.visible
			end),
			awful.button({ }, 4, function()
				aweful.tag.viewprev()
			end),
			awful.button({ }, 5, function()
				aweful.tag.viewnext()
			end)
	))
end

-- Item placement
sidebar:setup {
	{ -- Top
		pad(1),
		pad(1),
		time,
		date,
		fancy_date,
		pad(1),
		weather,
		layout = wibox.layout.fixed.vertical,
	},
	{ -- Middle
		pad(1),
		playerctl_buttons,
		{
			pad(2),
			mpris_song,
			pad(2),
			layout = wibox.layout.align.horizontal,
		},
		pad(1),
		volume,
		cpu,
		temperature,
		ram,
		battery,
		pad(1),
		disk,
		pad(1),
		pad(1),
		layout = wibox.layout.fixed.vertical,
	},
	{ -- Bottom
		{
			pad(5),
			{
				search,
				pad(32),
				exit,
				pad(2),
				layout = wibox.layout.fixed.horizontal,
			},
			pad(0),
			layout = wibox.layout.fixed.horizontal,
			expand = "none",
		},
		pad(1),
		layout = wibox.layout.fixed.vertical,
	},
	layout = wibox.layout.align.vertical,
}

