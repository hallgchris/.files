local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local pad = require("helpers").pad

-- Configuration
local update_interval = 60 * 5 -- in seconds

local disk_space = wibox.widget {
	text = "free disk space",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox
}

local function update_widget(disk_space_amount)
	disk_space.markup = disk_space_amount .. "B free"
end

local disk_script = [[
	bash -c "
	df -k -h /dev/sda5 | tail -1 | awk '{print $4}'
	"]]

awful.widget.watch(disk_script, update_interval, function(widget, stdout)
	local disk_space_amount = string.gsub(stdout, '^%s*(.-)%s*$', '%1')
	update_widget(disk_space_amount)
end)

disk_space.font = beautiful.sidebar_font .. " 13"
local disk_icon = wibox.widget.imagebox(beautiful.files_icon)
disk_icon.resize = true
disk_icon.forced_width = 40
disk_icon.forced_height = 40
local disk = wibox.widget {
	pad(0),
	{
		disk_icon,
		disk_space,
		layout = wibox.layout.fixed.horizontal
	},
	pad(0),
	expand = "none",
	layout = wibox.layout.align.horizontal
}

disk:buttons(gears.table.join(
	awful.button({ }, 1, function()
		awful.spawn(filemanager, { floating = true })
	end)
))

return disk
