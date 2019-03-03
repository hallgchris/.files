local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local lain = require("lain")
local naughty = require("naughty")
local wibox = require("wibox")

local helpers = require("helpers")
local separator = helpers.separator
local space = helpers.space

local markup = lain.util.markup

local scripts_dir = os.getenv("HOME") .. "/.scripts/"


local font = function(args)
	local args = args or {}
	args.name = args.name or "monospace"
	args.bold = args.bold or false
	args.italic = args.italic or false
	args.size = args.size or 11

	font_string = args.name
	if args.bold then font_string = font_string .. " Bold" end
	if args.italic then font_string = font_string .. " Italic" end
	font_string = font_string .. " " .. args.size

	return font_string
end

local markup_function = function(args, color)
	local font_string = font(args)

	return function(widget, text, fg)
		fg = fg or color
		widget:set_markup(markup.fontfg(font_string, fg, text))
	end
end

local text_markup_function = function(size, color)
	return markup_function({ size = size }, color)
end

local text_bold = markup_function({ bold=true, size=11 }, beautiful.bar_highlight, markup)
local text = markup_function(font_size, bar_fg, markup)


-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Textclock
-- local clock_icon = wibox.widget.imagebox(beautiful.widget_clock)
local clock = awful.widget.watch(
	-- "date +'%a %d %b %R'", 60,
	"date +'%R'", 5,
	function(widget, stdout)
		text_bold(widget, stdout, beautiful.bar_highlight)
	end
)

local clock_widget = wibox.widget {
	{
		clock,
		left = 4,
		right = 4,
		widget = wibox.container.margin,
	},
	layout = wibox.layout.align.horizontal,
}
-- }}}

-- {{{ Calendar
local cal = lain.widget.cal {
	attach_to = { clock_widget },
	followtag = true,
	week_start = 1,
	icons = "",
	notification_preset = naughty.config.presets.normal,
}
-- }}}


-- {{{ NET
-- local net_icon = wibox.widget.imagebox(beautiful.widget_net)
local net = lain.widget.net {
	--wifi_state = "on",
	--notify = "off",
	--units = 1048576, -- in MB/s (1024^2)
	-- units = 131072, -- in Mbit/s / Mbps (1024^2/8)
	settings = function()
		local _color = beautiful.bar_fg
		local _font = beautiful.font

		if not net_now.state or net_now.state == "down" then
			_color = beautiful.bar_critical
			widget:set_markup(markup.fontfg(_font, _color, " N/A "))
		else
			widget:set_markup(markup.fontfg(_font, _color, net_now.received .. " ↓↑ " .. net_now.sent))
		end
	end,
}

local net_widget = wibox.widget {
	{
		net.widget,
		left = 4,
		right = 4,
		widget = wibox.container.margin,
	},
	layout = wibox.layout.align.horizontal,
}

net_widget:connect_signal('mouse::enter', function()
	awful.spawn.easy_async(scripts_dir .. "show-ip-address", function(stdout, stderr, reason, exit_code)
		naughty.destroy(net_widget.notification)
		net.update()
		net_widget.notification = naughty.notify {
			title = "Network",
			text = string.gsub(stdout, '\n*$', ''),
			timeout = 10,
		}

		awful.spawn.easy_async(scripts_dir .. "show-ip-address -f", function(stdout, stderr, reason, exit_code)
			naughty.destroy(net_widget.notification)
			net.update()
			net_widget.notification = naughty.notify {
				title = "Network",
				text = string.gsub(stdout, '\n*$', ''),
				timeout = 10,
			}
		end)
	end)
end)
net_widget:connect_signal('mouse::leave', function()
	naughty.destroy(net_widget.notification)
end)
-- }}}

-- {{{ BAT
--luacheck: push ignore widget bat_now
local bat_icon = wibox.widget.imagebox(beautiful.widget_battery)
local bat = lain.widget.bat {
	notify = "off",
	--batteries = context.vars.batteries,
	--ac = context.vars.ac,
	settings = function()
		local _color = beautiful.bar_fg

		if tonumber(bat_now.perc) <= 10 then
			bat_icon:set_image(beautiful.widget_battery_empty)
			_color = beautiful.bar_critical
		elseif tonumber(bat_now.perc) <= 20 then
			bat_icon:set_image(beautiful.widget_battery_low)
			_color = beautiful.bar_warning
		elseif tonumber(bat_now.perc) <= 30 then
			bat_icon:set_image(beautiful.widget_battery_low)
			_color = beautiful.bar_attention
		elseif tonumber(bat_now.perc) <= 50 then
			bat_icon:set_image(beautiful.widget_battery_low)
		else
			bat_icon:set_image(beautiful.widget_battery)
		end

		if tonumber(bat_now.perc) <= 10 and not bat_now.ac_status == 1 then
			if not bat_now.notification then
				bat_now.notification = naughty.notify {
					title = "Battery",
					text = "Your battery is running low.\n"
						.. "You should plug in your PC.",
					preset = naughty.config.presets.critical,
					timeout = 0,
				}
			end
		end

		if bat_now.ac_status == 1 then
			bat_icon:set_image(beautiful.widget_ac)
			if tonumber(bat_now.perc) >= 95 then
				_color = beautiful.bat_fg_ac
			end
		end

		text(widget, bat_now.perc, _color)
	end,
}

local bat_widget = wibox.widget {
	bat_icon,
	{
		bat.widget,
		right = 4,
		widget = wibox.container.margin,
	},
	layout = wibox.layout.align.horizontal,
}

bat_widget:connect_signal('mouse::enter', function()
	awful.spawn.easy_async(scripts_dir .. "show-battery-status", function(stdout, stderr, reason, exit_code)
		naughty.destroy(bat_widget.notification)
		bat.update()
		bat_widget.notification = naughty.notify {
			title = "Battery",
			text = string.gsub(stdout, '\n*$', ''),
			timeout = 10,
		}
	end)
end)
bat_widget:connect_signal('mouse::leave', function()
	naughty.destroy(bat_widget.notification)
end)
-- }}}

-- {{{ pulseaudio volume
local vol_icon = wibox.widget.imagebox(beautiful.widget_vol)

local vol_text = wibox.widget {
	widget = wibox.widget.textbox,
}

local function update_widget()
	awful.spawn.easy_async({ awful.util.shell, "-c", "pactl list sinks"}, function(stdout)
		local volume = stdout:match("(%d+)%% /")
		local muted = stdout:match("Mute:(%s+)[yes]")
		if muted ~= nil then
			vol_icon:set_image(beautiful.widget_vol_mute)
		elseif tonumber(volume) < 50 then
			vol_icon:set_image(beautiful.widget_vol_low)
		else
			vol_icon:set_image(beautiful.widget_vol)
		end
		vol_text.markup = markup.fontfg(beautiful.font, beautiful.bar_fg, volume)
	end)
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

local vol_widget = wibox.widget {
	vol_icon,
	{
		vol_text,
		right = 4,
		widget = wibox.container.margin,
	},
	layout = wibox.layout.align.horizontal,
}

vol_widget:buttons(gears.table.join(
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
-- }}}

-- {{{ MEM
local mem_icon = wibox.widget.imagebox(beautiful.widget_mem)
local mem = lain.widget.mem {
	timeout = 5,
	settings = function()
		local _color = beautiful.bar_fg

		if tonumber(mem_now.perc) >= 90 then
			_color = beautiful.bar_critical
		elseif tonumber(mem_now.perc) >= 80 then
			_color = beautiful.bar_warning
		elseif tonumber(mem_now.perc) >= 70 then
			_color = beautiful.bar_attention
		end

		text(widget, mem_now.perc, _color)

		widget.used  = mem_now.used
		widget.total = mem_now.total
		widget.free  = mem_now.free
		widget.buf	 = mem_now.buf
		widget.cache = mem_now.cache
		widget.swap  = mem_now.swap
		widget.swapf = mem_now.swapf
		widget.srec  = mem_now.srec
	end,
}

local mem_widget = wibox.widget {
	mem_icon,
	{
		mem.widget,
		right = 4,
		widget = wibox.container.margin,
	},
	layout = wibox.layout.align.horizontal,
}

mem_widget:connect_signal('mouse::enter', function()
	naughty.destroy(mem_widget.notification)
	mem.update()
	mem_widget.notification = naughty.notify {
		title = "Memory",
		text = string.format("Total:  %.2fGB\n", tonumber(mem.widget.total) / 1024 + 0.5)
			.. string.format("Used:   %.2fGB\n", tonumber(mem.widget.used ) / 1024 + 0.5)
			.. string.format("Free:   %.2fGB\n", tonumber(mem.widget.free ) / 1024 + 0.5)
			.. string.format("Buffer: %.2fGB\n", tonumber(mem.widget.buf  ) / 1024 + 0.5)
			.. string.format("Cache:  %.2fGB\n", tonumber(mem.widget.cache) / 1024 + 0.5)
			.. string.format("Swap:   %.2fGB\n", tonumber(mem.widget.swap ) / 1024 + 0.5)
			.. string.format("Swapf:  %.2fGB\n", tonumber(mem.widget.swapf) / 1024 + 0.5)
			.. string.format("Srec:   %.2fGB"  , tonumber(mem.widget.srec ) / 1024 + 0.5),
		timeout = 10,
	}
end)
mem_widget:connect_signal('mouse::leave', function()
	naughty.destroy(mem_widget.notification)
end)
-- }}}

-- {{{ CPU
local cpu_icon = wibox.widget.imagebox(beautiful.widget_cpu)
local cpu = lain.widget.cpu {
	timeout = 5,
	settings = function()
		local _color = beautiful.bar_fg

		if tonumber(cpu_now.usage) >= 90 then
			_color = beautiful.bar_critical
		elseif tonumber(cpu_now.usage) >= 80 then
			_color = beautiful.bar_warning
		elseif tonumber(cpu_now.usage) >= 70 then
			_color = beautiful.bar_attention
		end

		text(widget, cpu_now.usage, _color)

		widget.core = cpu_now
	end,
}

local cpu_widget = wibox.widget {
	cpu_icon,
	{
		cpu.widget,
		right = 4,
		widget = wibox.container.margin,
	},
	layout = wibox.layout.align.horizontal,
}

cpu_widget:connect_signal('mouse::enter', function()
	naughty.destroy(cpu_widget.notification)
	cpu.update()
	cpu_widget.notification = naughty.notify {
		title = "CPU",
		text = string.format("Core 1: %d%%\n", cpu.widget.core[0].usage)
			.. string.format("Core 2: %d%%", cpu.widget.core[1].usage),
			--.. string.format("Core 3: %d%%\n", cpu.widget.core[2].usage)
			--.. string.format("Core 4: %d%%"  , cpu.widget.core[3].usage),
		timeout = 10,
	}
end)
cpu_widget:connect_signal('mouse::leave', function()
	naughty.destroy(cpu_widget.notification)
end)
-- }}}

-- {{{ SYSLOAD
local sysload_icon = wibox.widget.imagebox(beautiful.widget_hdd)
local sysload = lain.widget.sysload {
	timeout = 5,
	settings = function()
		local _color = beautiful.bar_fg

		-- check with: grep 'model name' /proc/cpuinfo | wc -l
		local cores = 4

		if tonumber(load_5) / cores >= 1.5 then
			_color = beautiful.bar_critical
		elseif tonumber(load_5) / cores >= 0.8 then
			if tonumber(load_1) > tonumber(load_5) then
				_color = beautiful.bar_critical
			else
				_color = beautiful.bar_warning
			end
		elseif tonumber(load_5) / cores >= 0.65 then
			_color = beautiful.bar_warning
		elseif tonumber(load_5) / cores >= 0.5 then
			_color = beautiful.bar_attention
		end

		text(widget, load_5, _color)

		widget.load_1  = load_1
		widget.load_5  = load_5
		widget.load_15 = load_15
	end,
}

local sysload_widget = wibox.widget {
	sysload_icon,
	{
		sysload.widget,
		right = 4,
		widget = wibox.container.margin,
	},
	layout = wibox.layout.align.horizontal,
}

sysload_widget:connect_signal('mouse::enter', function()
	naughty.destroy(sysload_widget.notification)
	sysload.update()
	sysload_widget.notification = naughty.notify {
		title = "Load Average",
		text = string.format(" 1min: %.2f\n", sysload.widget.load_1 )
			.. string.format(" 5min: %.2f\n", sysload.widget.load_5 )
			.. string.format("15min: %.2f"	, sysload.widget.load_15),
		timeout = 10,
	}
end)
sysload_widget:connect_signal('mouse::leave', function()
	naughty.destroy(sysload_widget.notification)
end)
-- }}}

-- {{{ CORETEMP (lain, average)
local temp_icon = wibox.widget.imagebox(beautiful.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        local _color = beautiful.bar_fg
        local _font = beautiful.font

        if tonumber(coretemp_now) >= 90 then
            _color = beautiful.bar_critical
        elseif tonumber(coretemp_now) >= 80 then
            _color = beautiful.bar_warning
        elseif tonumber(coretemp_now) >= 70 then
            _color = beautiful.bar_attention
        end
        widget:set_markup(markup.fontfg(_font, _color, coretemp_now))
    end,
})

local temp_widget = wibox.widget {
    temp_icon,
    {
        temp.widget,
        right = 4,
        widget = wibox.container.margin,
    },
    layout = wibox.layout.align.horizontal,
}

local update_kbd = function(widget, text)
	widget:set_markup(markup.fontfg(beautiful.font, beautiful.bar_fg, text))
end

local kbd_text = awful.widget.watch(scripts_dir .. "show-kb-layout", 10, update_kbd)

local kbd_widget = wibox.widget {
    --kbd_icon,
    {
        kbd_text,
        right = 4,
        widget = wibox.container.margin,
    },
    layout = wibox.layout.align.horizontal,
}
-- }}}

kbd_widget:buttons(gears.table.join(
	awful.button({ }, 1, function()
		awful.spawn.easy_async(scripts_dir .. "show-kb-layout", function(stdout)
			local new_layout = string.match(stdout, "colemak") and "us" or "us colemak"
			awful.spawn.easy_async("setxkbmap " .. new_layout, function()
				if new_layout == "us colemak" then new_layout = "us colemak" end
				update_kbd(kbd_text, new_layout)
			end)
		end)
	end)
))

local taglist = require("config.wibar.taglist")
local tasklist = require("config.wibar.tasklist")

bar = {}

function bar:init(env)

	awful.screen.connect_for_each_screen(function(s)

		-- Wallpaper
		env.wallpaper(s)

		-- Each screen has its own tag table.
		awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

		-- Create a promptbox for each screen
		s.mypromptbox = awful.widget.prompt()

		-- Create an imagebox widget which will contains an icon indicating which layout we're using.
		-- We need one layoutbox per screen.
		s.layoutbox = awful.widget.layoutbox(s)
		s.layoutbox:buttons(gears.table.join(
			awful.button({ }, 1, function() awful.layout.inc( 1) end),
			awful.button({ }, 3, function() awful.layout.inc(-1) end),
			awful.button({ }, 4, function() awful.layout.inc( 1) end),
			awful.button({ }, 5, function() awful.layout.inc(-1) end)
		))

		-- Create the wibox
		s.mywibox = awful.wibar({
			position = "top",
			height = 25 + beautiful.border_width,
			screen = s
		})

		-- Add widgets to the wibox
		s.mywibox:setup {
			{
				{ -- Left widgets
					space,
					{ -- Layout box
						{
							{
								layout = wibox.layout.align.horizontal,
								s.layoutbox,
							},
							left = 7,
							right = 7,
							top = 5,
							bottom = 5,
							widget = wibox.container.margin,
						},
						bg = bar_bg,
						widget = wibox.container.background,
					},
					{ -- Taglist
						{
							{
								layout = wibox.layout.align.horizontal,
								taglist.get(s),
							},
							left = 3,
							right = 3,
							widget = wibox.container.margin,
						},
						bg = bar_bg,
						widget = wibox.container.background,
					},
					space,
					separator,
					{ -- Prompt box
						{
							{
								layout = wibox.layout.align.horizontal,
								s.mypromptbox,
							},
							left = 6,
							right = 6,
							widget = wibox.container.margin,
						},
						bg = beautiful.prompt_bg,
						widget = wibox.container.background,
					},
					separator,
					layout = wibox.layout.fixed.horizontal,
				},
				tasklist.get(s), -- Middle widget
				{ -- Right widgets
					separator, space,
					wibox.widget.systray(),
					space, separator, space, space,

					kbd_widget, space,
					temp_widget, space,
					sysload_widget, space,
					cpu_widget, space,
					mem_widget, space,
					vol_widget, space,
					bat_widget, space,
					separator, space,

					net_widget, space,
					separator, space,

					clock_widget,
					space, space,

					layout = wibox.layout.fixed.horizontal,
				},
				layout = wibox.layout.align.horizontal,
			},
			bottom = beautiful.border_width,
			color = beautiful.border_normal,
			widget = wibox.container.margin
		}
	end)
end

return bar

