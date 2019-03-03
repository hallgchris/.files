local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local helpers = require("helpers")
local titlebars = {}

function titlebars.toggle_all()
	for i, c in ipairs(client.get()) do
		if not c.disable_toggle_all_titlebars then
			awful.titlebar.toggle(c, beautiful.titlebar_position)
		end
	end
	beautiful.titlebars_enabled = not beautiful.titlebars_enabled
end

function titlebars.toggle_current()
	awful.titlebar.toggle(client.focus, beautiful.titlebar_position)
end

-- Mouse buttons
titlebars.buttons = gears.table.join(
	-- Left button - move
	-- (Double tap - Toggle maximize) -- A little BUGGY
	awful.button({ }, 1, function()
		local c = mouse.object_under_pointer()
		client.focus = c
		c:raise()
		-- awful.mouse.client.move(c)
		local function single_tap()
			awful.mouse.client.move(c)
		end
		local function double_tap()
			gears.timer.delayed_call(function()
				c.maximized = not c.maximized
			end)
		end
		helpers.single_double_tap(single_tap, double_tap)
		-- helpers.single_double_tap(nil, double_tap)
	end),
	-- Middle button - close
	awful.button({ }, 2, function ()
		window_to_kill = mouse.object_under_pointer()
		window_to_kill:kill()
	end),
	-- Right button - resize
	awful.button({ }, 3, function()
		c = mouse.object_under_pointer()
		client.focus = c
		c:raise()
		awful.mouse.client.resize(c)
	end),
	-- Side button up - toggle floating
	awful.button({ }, 9, function()
		c = mouse.object_under_pointer()
		--client.focus = c
		--awful.placement.centered(c,{honor_workarea=true})
		c.floating = not c.floating
		c:raise()
	end),
	-- Side button down - toggle ontop
	awful.button({ }, 8, function()
		local c = mouse.object_under_pointer()
		c.ontop = not c.ontop
	end)
)

awful.titlebar.enable_tooltip = true

-- Add a titlebar
client.connect_signal("request::titlebars", function(c)
	local buttons = titlebars.buttons
	local vertical = beautiful.titlebar_position == "left" or beautiful.titlebar_position == "right"

	local title_widget
	if beautiful.titlebar_title_enabled then
		title_widget = awful.titlebar.widget.titlewidget(c)
		title_widget.font = beautiful.titlebar_font
		--title_widget:set_align(beautiful.titlebar_title_align)
	else
		title_widget = wibox.widget.textbox("")
	end

	local titlebar_item_layout
	local titlebar_layout
	local titlebar_text_direction
	if vertical then
		titlebar_item_layout = wibox.layout.fixed.vertical
		titlebar_layout = wibox.layout.align.vertical
		titlebar_text_direction = "west"
	else
		titlebar_item_layout = wibox.layout.fixed.horizontal
		titlebar_layout = wibox.layout.align.horizontal
		titlebar_text_direction = "north"
	end

	local text_widget_rotated = wibox.container {
		title_widget,
		direction = titlebar_text_direction,
		widget = wibox.container.rotate,
	}

	awful.titlebar(c, {
		font = beautiful.titlebar_font,
		position = beautiful.titlebar_position,
		size = beautiful.titlebar_size
	}):setup {
		-- Titlebar items
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			vertical and helpers.vpad(1) or helpers.pad(1),
			text_widget_rotated,
			-- In the presence of buttons, use padding to center the title (if centered).
			-- helpers.pad(20),
			buttons = buttons,
			--position = "top",
			layout	= titlebar_item_layout
		},
		{ -- Middle
			--[[ Uncomment for centered title, also the pad(20) above
			{ -- Title
				align  = beautiful.titlebar_title_align,
				widget = title_widget_rotated
			},
			--]]
			buttons = buttons,
			layout = titlebar_layout,
		},
		{ -- Right
			-- Clickable buttons
			awful.titlebar.widget.floatingbutton (c),
			--awful.titlebar.widget.stickybutton   (c),
			awful.titlebar.widget.ontopbutton	 (c),
			awful.titlebar.widget.minimizebutton (c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.closebutton	 (c),
			--buttons = buttons,
			layout = titlebar_item_layout
			--layout = wibox.layout.fixed.horizontal()
		},
		layout = titlebar_layout
		--layout = wibox.layout.align.horizontal
	}
end)

return titlebars

