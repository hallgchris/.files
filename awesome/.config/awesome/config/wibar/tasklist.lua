local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local helpers = require("helpers")
local separator = helpers.separator

local tasklist_generator = { }

tasklist_generator.get = function(s)

	local tasklist

	local tasklist_buttons = gears.table.join(
		awful.button({ }, 1, function (c)
			if c == client.focus then
				c.minimized = true
			else
				-- Without this, the following
				-- :isvisible() makes no sense
				c.minimized = false
				if not c:isvisible() and c.first_tag then
					c.first_tag:view_only()
				end
				-- This will also un-minimize
				-- the client, if needed
				client.focus = c
				c:raise()
			end
		end),
		awful.button({ }, 3, helpers.client_menu_toggle()),
		awful.button({ }, 4, function() awful.client.focus.byidx(1)	end),
		awful.button({ }, 5, function()	awful.client.focus.byidx(-1) end)
	)

	local gen_tasklist = function()
		-- Create a tasklist widget
		tasklist = awful.widget.tasklist {
			screen = s,
			filter = awful.widget.tasklist.filter.currenttags,
			buttons = tasklist_buttons,
			bg_focus = beautiful.tasklist_bg_focus,
			style = {
				shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, beautiful.border_radius or 0)
				end,
				shape_border_width = 0,
				shape_border_color = beautiful.tasklist_bg_normal,
			},
			widget_template = {
				{
					{
						{
							{
								id	   = "text_role",
								widget = wibox.widget.textbox,
							},
							layout = wibox.layout.fixed.horizontal,
						},
						widget = wibox.container.place,
					},
					left = 5,
					right = 5,
					widget = wibox.container.margin,
				},
				create_callback = function(self, c, index, objects) --luacheck: no unused args
					local tooltip = awful.tooltip { --luacheck: no unused
						objects = { self },
						delay_show = 1,
						timer_function = function()
							return c.name
						end,
						align = "bottom",
						mode = "outside",
						preferred_positions = { "bottom" },
					}
				end,
				id = "background_role",
				widget = wibox.container.background,
			},
			layout = {
				layout = wibox.layout.flex.horizontal,
				spacing = 8,
				spacing_widget = {
					separator,
					widget = wibox.container.place,
				},
			},
		}
	end

	if not pcall(gen_tasklist) then
		-- Create a tasklist widget
		tasklist = awful.widget.tasklist(
			s,
			awful.widget.tasklist.filter.currenttags,
			tasklist_buttons, {
				bg_focus = beautiful.tasklist_bg_focus,
				shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, beautiful.border_radius or 0)
				end,
			shape_border_width = 0,
			shape_border_color = beautiful.tasklist_bg_normal,
			align = "center"
		})
	end

	return tasklist
end

return tasklist_generator

