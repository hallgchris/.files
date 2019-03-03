local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local helpers = {}

helpers.rect = function()
	return function (cr, width, height)
		gears.shape.rectangle(cr, width, height)
	end	
end

-- rounded rectangle
helpers.rrect = function(radius)
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, radius)
	end
end

-- partially rounded rectangle
helpers.prrect = function(radius, tl, tr, br, bl)
	return function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
	end
end

function helpers.colorize_text(text, fg)
	return "<span foreground='" .. fg .. "'>" .. text .. "</span>"
end

helpers.client_menu_toggle = function()
    local instance = nil
    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

function helpers.pad(size)
	local str = ""
	for i = 1, size do
		str = str .. " "
	end
	local pad = wibox.widget.textbox(str)
	return pad
end

function helpers.vpad(size)
	return wibox.container {
		helpers.pad(size),
		direction = "east",
		widget = wibox.container.rotate,
	}
end

helpers.space = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "vertical",
    forced_width = 3,
    thickness = 3,
    color = "#00000000",
}

helpers.separator = wibox.widget {
	widget = wibox.widget.separator,
	orientation = "vertical",
	forced_width = beautiful.border_width / 2,
	thickness = beautiful.border_width / 2,
	color = beautiful.border_normal,
}

local double_tap_timer = nil
function helpers.single_double_tap(single_tap_function, double_tap_function)
	if double_tap_timer then
		double_tap_timer:stop()
		double_tap_timer = nil
		double_tap_function()
		return
	end

	double_tap_timer = gears.timer.start_new(0.20, function()
		double_tap_timer = nil
		single_tap_function()
		return false
    end)
end

function helpers.volume_control(arg)
	awful.spawn.with_shell("~/.scripts/volume-control.sh " .. arg)
end

return helpers

