-- Spacing
local space = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "vertical",
    forced_width = 3,
    thickness = 3,
    color = "#00000000",
}

-- Separator
local vert_sep = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "vertical",
    forced_width = theme.border_width / 2,
    thickness = theme.border_width / 2,
    color = theme.border_normal,
}

-- Markup
local symbol = context.util.symbol_markup_function(8, bar_fg, markup)
local text = context.util.text_markup_function(font_size, bar_fg, markup)
local text_bold = context.util.markup_function({bold=true, size=font_size}, bar_fg, markup)

-- {{{ Textclock
-- local clock_icon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
    -- "date +'%a %d %b %R'", 60,
    "date +'%R'", 5,
    function(widget, stdout)
        text_bold(widget, stdout, colors.bw_8)
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
    cal = "cal --color=always --monday",
    attach_to = { clock_widget },
    icons = "",
    notification_preset = naughty.config.presets.normal,
}
-- }}}

-- -- {{{ Mail IMAP check
-- local mail_icon = wibox.widget.imagebox(theme.widget_mail)
-- --[[ commented because it needs to be set before use
-- mail_icon:buttons(gears.table.join(awful.button({ }, 1, function() awful.spawn(mail) end)))
-- local mail = lain.widget.imap({
--     timeout  = 180,
--     server   = "server",
--     mail     = "mail",
--     password = "keyring get mail",
--     settings = function()
--         if mailcount > 0 then
--             widget:set_text(" " .. mailcount .. " ")
--             mail_icon:set_image(theme.widget_mail_on)
--         else
--             widget:set_text("")
--             mail_icon:set_image(theme.widget_mail)
--         end
--     end,
-- })
-- -- }}}

-- {{{ MPD
--luacheck: push ignore widget mpd_now artist title
-- local musicplr = context.vars.terminal .. " -title Music -g 130x34-320+16 ncmpcpp"
local mpd_icon = wibox.widget.imagebox(theme.widget_music)

-- mpd_icon:buttons(gears.table.join(
--     awful.button({ context.keys.modkey }, 1, function()
--         awful.spawn.with_shell(musicplr)
--     end),
--     awful.button({ }, 1, function()
--         awful.spawn.with_shell("mpc prev")
--         theme.mpd.update()
--     end),
--     awful.button({ }, 2, function()
--         awful.spawn.with_shell("mpc toggle")
--         theme.mpd.update()
--     end),
--     awful.button({ }, 3, function()
--         awful.spawn.with_shell("mpc next")
--         theme.mpd.update()
--     end)))

theme.mpd = lain.widget.mpd {
    settings = function()
        if mpd_now.state == "play" then
            artist = " " .. mpd_now.artist .. " "
            title  = mpd_now.title  .. " "
            mpd_icon:set_image(theme.widget_music_on)
            widget:set_markup(markup.font(theme.font, markup("#FF8466", artist) .. " " .. title))
        elseif mpd_now.state == "pause" then
            widget:set_markup(markup.font(theme.font, " mpd paused "))
            mpd_icon:set_image(theme.widget_music_pause)
        else
            widget:set_text("")
            mpd_icon:set_image(theme.widget_music)
        end
    end,
}
--luacheck: pop
-- }}}

-- {{{ MEM
--luacheck: push ignore widget mem_now
local mem_icon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem {
    timeout = 5,
    settings = function()
        local _color = bar_fg

        if tonumber(mem_now.perc) >= 90 then
            _color = colors.red_2
        elseif tonumber(mem_now.perc) >= 80 then
            _color = colors.orange_2
        elseif tonumber(mem_now.perc) >= 70 then
            _color = colors.yellow_2
        end

        text(widget, mem_now.perc, _color)

        widget.used  = mem_now.used
        widget.total = mem_now.total
        widget.free  = mem_now.free
        widget.buf   = mem_now.buf
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

mem_widget:buttons(awful.button({ }, 1, function()
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
end))
--luacheck: pop
-- }}}

-- {{{ CPU
--luacheck: push ignore widget cpu_now
local cpu_icon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu {
    timeout = 5,
    settings = function()
        local _color = bar_fg

        if tonumber(cpu_now.usage) >= 90 then
            _color = colors.red_2
        elseif tonumber(cpu_now.usage) >= 80 then
            _color = colors.orange_2
        elseif tonumber(cpu_now.usage) >= 70 then
            _color = colors.yellow_2
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

cpu_widget:buttons(awful.button({ }, 1, function()
    naughty.destroy(cpu_widget.notification)
    cpu.update()
    cpu_widget.notification = naughty.notify {
        title = "CPU",
        text = string.format("Core 1: %d%%\n", cpu.widget.core[0].usage)
            .. string.format("Core 2: %d%%\n", cpu.widget.core[1].usage)
            .. string.format("Core 3: %d%%\n", cpu.widget.core[2].usage)
            .. string.format("Core 4: %d%%"  , cpu.widget.core[3].usage),
        timeout = 10,
    }
end))
--luacheck: pop
-- }}}

-- {{{ SYSLOAD
--luacheck: push ignore widget load_1 load_5 load_15
local sysload_icon = wibox.widget.imagebox(theme.widget_hdd)
local sysload = lain.widget.sysload {
    timeout = 5,
    settings = function()
        local _color = bar_fg

        -- check with: grep 'model name' /proc/cpuinfo | wc -l
        local cores = context.vars.cores or 4

        if tonumber(load_5) / cores >= 1.5 then
            _color = colors.red_2
        elseif tonumber(load_5) / cores >= 0.8 then
            if tonumber(load_1) > tonumber(load_5) then
                _color = colors.red_2
            else
                _color = colors.orange_2
            end
        elseif tonumber(load_5) / cores >= 0.65 then
            _color = colors.orange_2
        elseif tonumber(load_5) / cores >= 0.5 then
            _color = colors.yellow_2
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

sysload_widget:buttons(awful.button({ }, 1, function()
    naughty.destroy(sysload_widget.notification)
    sysload.update()
    sysload_widget.notification = naughty.notify {
        title = "Load Average",
        text = string.format(" 1min: %.2f\n", sysload.widget.load_1 )
            .. string.format(" 5min: %.2f\n", sysload.widget.load_5 )
            .. string.format("15min: %.2f"  , sysload.widget.load_15),
        timeout = 10,
    }
end))
--luacheck: pop
-- }}}

-- {{{ PACMAN
--luacheck: push ignore widget available
local pacman_icon = wibox.widget.imagebox(theme.widget_pacman)
theme.pacman = widgets.pacman {
    command = context.vars.checkupdate,
    notify = "on",
    notification_preset = naughty.config.presets.normal,
    settings = function()
        text(widget, available)
    end,
}

local pacman_widget = wibox.widget {
    pacman_icon,
    {
        theme.pacman.widget,
        right = 4,
        widget = wibox.container.margin,
    },
    layout = wibox.layout.align.horizontal,
}

pacman_widget:buttons(awful.button({ }, 1, function()
    theme.pacman.manual_update()
end))
--luacheck: pop
-- }}}

-- {{{ USERS
--luacheck: push ignore widget logged_in
local users_icon = wibox.widget.imagebox(theme.widget_users)
local users = widgets.users {
    settings = function()
        local _color = bar_fg
        if tonumber(logged_in) > 1 then
            _color = colors.red_2
        end
        text(widget, logged_in, _color)
    end,
}

local users_widget = wibox.widget {
    users_icon,
    {
        users.widget,
        right = 4,
        widget = wibox.container.margin,
    },
    layout = wibox.layout.align.horizontal,
}

users_widget:buttons(awful.button({ }, 1, function()
    awful.spawn.easy_async("users", function(stdout, stderr, reason, exit_code)
        naughty.destroy(users_widget.notification)
        users.update()
        users_widget.notification = naughty.notify {
            title = "Users",
            text = string.gsub(string.gsub(stdout, '\n*$', ''), ' ', '\n'),
            timeout = 10,
        }
    end)
end))
--luacheck: pop
-- }}}

-- {{{ LIGHT
--luacheck: push ignore widget percent
local light_icon = wibox.widget.imagebox(theme.widget_light)
theme.light = widgets.light {
    settings = function()
        text(widget, percent)
    end,
}

local light_widget = wibox.widget {
    light_icon,
    {
        theme.light.widget,
        right = 4,
        widget = wibox.container.margin,
    },
    layout = wibox.layout.align.horizontal,
}

light_widget:buttons(gears.table.join(
    awful.button({ }, 1, function()
        awful.spawn.easy_async("light -G", function(stdout, stderr, reason, exit_code) --luacheck: no unused args
            naughty.destroy(light_widget.notification)
            theme.light.update()
            light_widget.notification = naughty.notify {
                title = "light",
                text = string.gsub(string.gsub(stdout, '\n*$', ''), ' ', '\n'),
                timeout = 10,
            }
        end)
    end),
    awful.button({ }, 4, function()
        awful.spawn.easy_async("light -U 2",
        function(stdout, stderr, reason, exit_code) --luacheck: no unused args
            theme.light.update()
        end)
    end),
    awful.button({ }, 5, function()
        awful.spawn.easy_async("light -A 2",
        function(stdout, stderr, reason, exit_code) --luacheck: no unused args
            theme.light.update()
        end)
    end)
))
--luacheck: pop
-- }}}

-- -- {{{ CORETEMP (lm_sensors, per core)
-- local tempwidget = awful.widget.watch({awful.util.shell, '-c', 'sensors | grep Core'}, 30,
-- function(widget, stdout)
--     local temps = ""
--     for line in stdout:gmatch("[^\r\n]+") do
--         temps = temps .. line:match("+(%d+).*°C")  .. "° " -- in Celsius
--     end
--     widget:set_markup(markup.font(theme.font, " " .. temps))
-- end)
-- -- }}}

-- -- {{{ CORETEMP (lain, average)
-- local temp_icon = wibox.widget.imagebox(theme.widget_temp)
-- local temp = lain.widget.temp({
--     tempfile = "/sys/class/thermal/thermal_zone7/temp",
--     settings = function()
--         local _color = bar_fg
--         local _font = theme.font
--
--         if tonumber(coretemp_now) >= 90 then
--             _color = colors.red_2
--         elseif tonumber(coretemp_now) >= 80 then
--             _color = colors.orange_2
--         elseif tonumber(coretemp_now) >= 70 then
--             _color = colors.yellow_2
--         end
--         widget:set_markup(markup.fontfg(_font, _color, coretemp_now))
--     end,
-- })
--
-- local temp_widget = wibox.widget {
--     temp_icon,
--     {
--         temp.widget,
--         right = 4,
--         widget = wibox.container.margin,
--     },
--     layout = wibox.layout.align.horizontal,
-- }
-- -- }}}

-- -- {{{ FS
-- local fs_icon = wibox.widget.imagebox(theme.widget_hdd)
-- theme.fs = lain.widget.fs({
--     options  = "--exclude-type=tmpfs",
--     notification_preset = { fg = bar_fg, bg = theme.border_normal, font = "xos4 Terminus 10" },
--     settings = function()
--         widget:set_markup(markup.fontfg(theme.font, bar_fg, " " .. fs_now.available_gb .. "GB "))
--     end,
-- })
--
-- local fs_widget = wibox.widget {
--     fs_icon,
--     {
--         theme.fs.widget,
--         right = 4,
--         widget = wibox.container.margin,
--     },
--     layout = wibox.layout.align.horizontal,
-- }
-- -- }}}

-- {{{ ALSA volume
--luacheck: push ignore widget volume_now vol_text volume_before
local vol_icon = wibox.widget.imagebox(theme.widget_vol)
theme.volume = lain.widget.alsa {
    -- togglechannel = "IEC958,3",
    settings = function()
        if volume_now.status == "off" then
            vol_icon:set_image(theme.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            vol_icon:set_image(theme.widget_vol_no)
        elseif tonumber(volume_now.level) < 50 then
            vol_icon:set_image(theme.widget_vol_low)
        else
            vol_icon:set_image(theme.widget_vol)
        end

        text(widget, volume_now.level)

        if theme.volume.manual then
            naughty.destroy(theme.volume.notification)

            if volume_now.status == "off" then
                vol_text = "Muted"
            else
                vol_text = " " .. volume_now.level .. "%"
            end

            if client.focus and client.focus.fullscreen or volume_now.status ~= volume_before then
                theme.volume.notification = naughty.notify {
                    title = "Audio",
                    text = vol_text,
                    timeout = 10,
                }
            end

            theme.volume.manual = false
        end
        volume_before = volume_now.status
    end,
}

-- Initial notification
theme.volume.manual = true
theme.volume.update()

local vol_widget = wibox.widget {
    vol_icon,
    {
        theme.volume.widget,
        right = 4,
        widget = wibox.container.margin,
    },
    layout = wibox.layout.align.horizontal,
}

vol_widget:buttons(gears.table.join(
    awful.button({ }, 1, function()
        awful.spawn.easy_async(string.format("amixer -q set %s toggle", theme.volume.channel),
        function(stdout, stderr, reason, exit_code) --luacheck: no unused args
            theme.volume.manual = true
            theme.volume.update()
        end)
    end),
    awful.button({ }, 4, function()
        awful.spawn.easy_async(string.format("amixer -q set %s 1%%-", theme.volume.channel),
        function(stdout, stderr, reason, exit_code) --luacheck: no unused args
            theme.volume.update()
        end)
    end),
    awful.button({ }, 5, function()
        awful.spawn.easy_async(string.format("amixer -q set %s 1%%+", theme.volume.channel),
        function(stdout, stderr, reason, exit_code) --luacheck: no unused args
            theme.volume.update()
        end)
    end)
))
--luacheck: pop
-- }}}

-- {{{ BAT
--luacheck: push ignore widget bat_now
local bat_icon = wibox.widget.imagebox(theme.widget_battery)
local bat = lain.widget.bat {
    notify = "off",
    batteries = context.vars.batteries,
    ac = context.vars.ac,
    settings = function()
        local _color = bar_fg

        if tonumber(bat_now.perc) <= 10 then
            bat_icon:set_image(theme.widget_battery_empty)
            _color = colors.red_2
        elseif tonumber(bat_now.perc) <= 20 then
            bat_icon:set_image(theme.widget_battery_low)
            _color = colors.orange_2
        elseif tonumber(bat_now.perc) <= 30 then
            bat_icon:set_image(theme.widget_battery_low)
            _color = colors.yellow_2
        elseif tonumber(bat_now.perc) <= 50 then
            bat_icon:set_image(theme.widget_battery_low)
        else
            bat_icon:set_image(theme.widget_battery)
        end

        if tonumber(bat_now.perc) <= 3 and not bat_now.ac_status == 1 then
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
            bat_icon:set_image(theme.widget_ac)
            if tonumber(bat_now.perc) >= 95 then
                _color = colors.green_2
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

bat_widget:buttons(awful.button({ }, 1, function()
    awful.spawn.easy_async(context.vars.scripts_dir .. "/show-battery-status", function(stdout, stderr, reason, exit_code)
        naughty.destroy(bat_widget.notification)
        bat.update()
        bat_widget.notification = naughty.notify {
            title = "Battery",
            text = string.gsub(stdout, '\n*$', ''),
            timeout = 10,
        }
    end)
end))
--luacheck: pop
-- }}}

-- -- {{{ WEATHER
-- local weather = lain.widget.weather({
--     city_id = 2661604,
--     settings = function()
--         units = math.floor(weather_now["main"]["temp"])
--         widget:set_markup(markup.fontfg(theme.font, bar_fg, " " .. units .. "°C "))
--     end,
-- })
--
-- weather_widget = wibox.widget {
--     weather.icon,
--     {
--         weather.widget,
--         right = 4,
--         widget = wibox.container.margin,
--     },
--     layout = wibox.layout.align.horizontal,
-- }
-- -- }}}

-- {{{ NET
--luacheck: push ignore widget net_now
-- local net_icon = wibox.widget.imagebox(theme.widget_net)
local net = lain.widget.net {
    wifi_state = "on",
    iface = context.vars.net_iface,
    notify = "off",
    units = 1048576, -- in MB/s (1024^2)
    -- units = 131072, -- in Mbit/s / Mbps (1024^2/8)
    settings = function()
        local _color = bar_fg
        local _font = theme.font

        if not net_now.state or net_now.state == "down" then
            _color = colors.red_2
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

net_widget:buttons(awful.button({ }, 1, function()
    awful.spawn.easy_async(context.vars.scripts_dir .. "/show-ip-address", function(stdout, stderr, reason, exit_code)
        naughty.destroy(net_widget.notification)
        net.update()
        net_widget.notification = naughty.notify {
            title = "Network",
            text = string.gsub(stdout, '\n*$', ''),
            timeout = 10,
        }

        awful.spawn.easy_async(context.vars.scripts_dir .. "/show-ip-address -f", function(stdout, stderr, reason, exit_code)
            naughty.destroy(net_widget.notification)
            net.update()
            net_widget.notification = naughty.notify {
                title = "Network",
                text = string.gsub(stdout, '\n*$', ''),
                timeout = 10,
            }
        end)
    end)
end))
--luacheck: pop
-- }}}

-- NOTE: This will be called after fully initializing the context-object, so
--       context.util etc. can be used here.
function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake {
        app = context.vars.terminal,
    }

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    -- gears.wallpaper.maximized(wallpaper, s, true)
    gears.wallpaper.tiled(wallpaper, s)

    -- Add tags if there are none
    if #s.tags == 0 then
        awful.tag(awful.util.tagnames, s, awful.util.layouts)
    end

    -- Create a promptbox for each screen
    s._promptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s._layoutbox = awful.widget.layoutbox(s)
    s._layoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function() awful.layout.inc( 1) end),
        awful.button({ }, 3, function() awful.layout.inc(-1) end),
        awful.button({ }, 4, function() awful.layout.inc( 1) end),
        awful.button({ }, 5, function() awful.layout.inc(-1) end))
    )

    -- Create a taglist widget
    s._taglist = awful.widget.taglist{
        screen = s,
        filter = context.util.rowfilter,
        buttons = awful.util.taglist_buttons,
    }

    local gen_tasklist = function()
        -- Create a tasklist widget
        s._tasklist = awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = awful.util.tasklist_buttons,
            bg_focus = theme.tasklist_bg_focus,
            style = {
                shape = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height, theme.border_radius or 0)
                end,
                shape_border_width = 0,
                shape_border_color = theme.tasklist_bg_normal,
            },
            widget_template = {
                {
                    {
                        {
                            {
                                id     = "text_role",
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
                    vert_sep,
                    widget = wibox.container.place,
                },
            },
        }
    end

    -- For old version (Awesome v4.2)
    if not pcall(gen_tasklist) then
        -- Create a tasklist widget
        s._tasklist = awful.widget.tasklist(s,
        awful.widget.tasklist.filter.currenttags,
        awful.util.tasklist_buttons, {
            bg_focus = theme.tasklist_bg_focus,
            shape = function(cr, width, height)
                        gears.shape.rounded_rect(cr, width, height, theme.border_radius or 0)
                    end,
            shape_border_width = 0,
            shape_border_color = theme.tasklist_bg_normal,
            align = "center" })
    end

    -- Create the wibox
    s._wibox = awful.wibar {
        position = "top",
        screen = s,
        height = 25 + theme.border_width,
        fg = bar_fg,
        bg = bar_bg,
    }

    local systray_widget = wibox.widget {
        layout = wibox.layout.align.horizontal,
        vert_sep,
        {
            {
                layout = wibox.layout.align.horizontal,
                wibox.widget.systray(),
            },
            left = 8,
            right = 8,
            top = 4,
            bottom = 4,
            widget = wibox.container.margin,
        },
        visible = false,
    }
    context.util.show_on_mouse(s._wibox, systray_widget)

    -- Add widgets to the wibox
    s._wibox:setup {
        {
            layout = wibox.layout.flex.vertical,
            {
                layout = wibox.layout.align.horizontal,
                { -- Left widgets
                    layout = wibox.layout.fixed.horizontal,

                    space, space,

                    { -- Layout box
                        {
                            {
                                layout = wibox.layout.align.horizontal,
                                s._layoutbox,
                            },
                            left = 4,
                            top = 5,
                            bottom = 5,
                            widget = wibox.container.margin,
                        },
                        bg = bar_bg,
                        widget = wibox.container.background,
                    },

                    space,

                    { -- Taglist
                        {
                            {
                                layout = wibox.layout.align.horizontal,
                                s._taglist,
                            },
                            left = 2,
                            right = 2,
                            widget = wibox.container.margin,
                        },
                        bg = bar_bg,
                        widget = wibox.container.background,
                    },

                    space,

                    vert_sep,

                    { -- Prompt box
                        {
                            {
                                layout = wibox.layout.align.horizontal,
                                s._promptbox,
                            },
                            left = 6,
                            right = 6,
                            widget = wibox.container.margin,
                        },
                        bg = theme.prompt_bg,
                        widget = wibox.container.background,
                    },

                    vert_sep,
                },

                -- Middle widget
                { -- Tasklist
                    {
                        {
                            layout = wibox.layout.flex.horizontal,
                            s._tasklist,
                        },
                        left = 2,
                        right = 2,
                        widget = wibox.container.margin,
                    },
                    bg = bar_bg,
                    widget = wibox.container.background,
                },

                { -- Right widgets
                    layout = wibox.layout.fixed.horizontal,

                    systray_widget,

                    vert_sep, space,

                    -- fs_widget, space,
                    -- temp_widget, space,
                    pacman_widget, space,
                    users_widget, space,
                    sysload_widget, space,
                    cpu_widget, space,
                    mem_widget, space,
                    light_widget, space,
                    vol_widget, space,
                    bat_widget, space,

                    vert_sep, space,

                    net_widget, space,

                    vert_sep, space,

                    clock_widget,

                    space, space,
                },
            },
        },
        bottom = theme.border_width,
        color = theme.border_normal,
        widget = wibox.container.margin,
    }

    -- {{{ POPUPS
    local popup_font = context.util.font { size = 20 , bold = true }

    -- Layoutbox popup
    s._layout_popup = context.util.popup {
        widget = awful.widget.layoutbox(s),
    }

    -- Taglist popup
    s._taglist_popup = context.util.popup {
        widget = awful.widget.taglist {
            screen = s,
            filter = context.util.rowfilter,
            buttons = awful.util.taglist_buttons,
            style = {
                font = popup_font,
                bg_focus = theme.taglist_bg_normal,
                bg_urgent = theme.taglist_bg_normal,
            },
            layout = {
                spacing = 8,
                layout = wibox.layout.fixed.horizontal
            },
        },
        width = 330,
        height = 72,
    }

    -- }}}

end

