local awful = require("awful")
local beautiful = require("beautiful")

local helpers = require("helpers")
local env = require("config.env")


-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and
	  not c.size_hints.user_position
	  and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end

	-- Hide titlebars if required by the theme
	if not beautiful.titlebars_enabled then
		awful.titlebar.hide(c, beautiful.titlebar_position)
	end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
		and awful.client.focus.filter(c) then
		client.focus = c
	end
end)

--client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
--client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Rounded corners
if beautiful.border_radius ~= 0 then
	client.connect_signal("manage", function (c, startup)
		if not c.fullscreen then
			c.shape = helpers.rrect(beautiful.border_radius)
		end
	end)

	-- Fullscreen clients should not have rounded corners
	client.connect_signal("property::fullscreen", function(c)
		if c.fullscreen then
			c.shape = helpers.rect()
		else
			c.shape = helpers.rrect(beautiful.border_radius)
		end
	end)
end

-- Disable borders on lone windows
-- Handle border sizes of clients.
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
  local clients = awful.client.visible(s)
  local layout = awful.layout.getname(awful.layout.get(s))

  for _, c in pairs(clients) do
	-- No borders with only one humanly visible client
	if c.maximized then
	  -- NOTE: also handled in focus, but that does not cover maximizing from a
	  -- tiled state (when the client had focus).
	  c.border_width = 0
	elseif c.floating or layout == "floating" then
	  c.border_width = beautiful.border_width
	elseif layout == "max" or layout == "fullscreen" then
	  c.border_width = 0
	else
	  local tiled = awful.client.tiled(c.screen)
	  if #tiled == 1 then -- and c == tiled[1] then
		tiled[1].border_width = 0
		-- if layout ~= "max" and layout ~= "fullscreen" then
		-- XXX: SLOW!
		-- awful.client.moveresize(0, 0, 2, 0, tiled[1])
		-- end
	  else
		c.border_width = beautiful.border_width
	  end
	end
  end
end)
end

client.connect_signal("property::floating", function (c)
	  if c.floating then
		  awful.titlebar.show(c)
	  else
		  awful.titlebar.hide(c)
	  end
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", env.wallpaper)


