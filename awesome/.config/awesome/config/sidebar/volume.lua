-- This widget runs a script in the background
-- When awesome restarts, its process will remain alive!
-- Don't worry though! The cleanup script that runs in rc.lua takes care of it :)

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local helpers = require("helpers")
local pad = helpers.pad

-- Set colors
local active_color = beautiful.volume_bar_active_color or "#5AA3CC"
local muted_color = beautiful.volume_bar_muted_color or "#666666"
local active_background_color = beautiful.volume_bar_active_background_color or "#222222"
local muted_background_color = beautiful.volume_bar_muted_background_color or "#222222"

local volume_bar = wibox.widget {
	max_value = 100,
	value = 50,
	forced_height = 10,
	margins = {
		top = 10,
		bottom = 10,
	},
	forced_width = 200,
	shape = gears.shape.rounded_bar,
	bar_shape = gears.shape.rounded_bar,
	color = active_color,
	background_color = active_background_color,
	border_width = 0,
	border_color = beautiful.border_color,
	widget = wibox.widget.progressbar,
}

local volume_icon = wibox.widget.imagebox(beautiful.volume_icon)
volume_icon.resize = true
volume_icon.forced_width = 40
volume_icon.forced_height = 40

local function update_widget()
	awful.spawn.easy_async({ awful.util.shell, "-c", "pactl list sinks"},
		function(stdout)
			local volume = stdout:match("(%d+)%% /")
			local muted = stdout:match("Mute:(%s+)[yes]")
			local fill_color
			local bg_color
			local icon
			if muted ~= nil then
				fill_color = muted_color
				bg_color = muted_background_color
				icon = beautiful.muted_icon
			else
				fill_color = active_color
				bg_color = active_background_color
				icon = beautiful.volume_icon
			end
			volume_bar.value = tonumber(volume)
			volume_bar.color = fill_color
			volume_bar.background_color = bg_color
			volume_icon.image = icon
		end
	)
end

update_widget()

-- Sleeps until pactl detects an event (volume up/down/toggle mute)
local volume_script = [[
	bash -c '
	pactl subscribe 2> /dev/null | grep --line-buffered "sink #0"
	']]

awful.spawn.with_line_callback(volume_script, {
	stdout = function(line)
		update_widget()
	end
})

local volume = wibox.widget {
	pad(0),
	{
		volume_icon,
		pad(1),
		volume_bar,
		layout = wibox.layout.fixed.horizontal
	},
	pad(0),
	expand = "none",
	layout = wibox.layout.align.horizontal
}

volume:buttons(gears.table.join(
	-- Left click - Mute / Unmute
	awful.button({ }, 1, function()
		helpers.volume_control("toggle")
	end),

	-- Right click - run or raise pavucontrol
	awful.button({ }, 3, function()
		local matcher = function(c)
			return awful.rules.match(c, { class = "Pavucontrol" })
		end
		awful.client.run_or_raise("pavucontrol", matcher)
	end),

	-- Scroll - Increase / Decrease volume
	awful.button({ }, 4, function()
		helpers.volume_control("up")
	end),
	awful.button({ }, 5, function()
		helpers.volume_control("down")
	end)
))


return volume

