local naughty = require("naughty")
local io = require("io")

local common = { }

function common.alacritty_colors(colors)
	local template = io.open(os.getenv("HOME") .. "/.config/alacritty/alacritty_template.yml")
	modified = string.format(template:read("*a"),
		colors.black_1, colors.white_2,
		colors.black_1, colors.red_1, colors.green_1, colors.yellow_1,
		colors.blue_1, colors.purple_1, colors.aqua_1, colors.white_1,
		colors.black_2, colors.red_2, colors.green_2, colors.yellow_2,
		colors.blue_2, colors.purple_2, colors.aqua_2, colors.white_2)
	output = io.open(os.getenv("HOME") .. "/.config/alacritty/alacritty.yml", "w"):write(modified)
	template:close()
	output:close()
end

function common.init(theme, colors)

	common.alacritty_colors(colors)

	theme.wallpaper = theme.dir .. "/wallpapers/wall.png"

	theme.titlebars_enabled							= true
	theme.titlebar_position							= "right"
	theme.titlebar_title_enabled					= true

	local font_name									= "monospace"
	local font_size									= "11"
	theme.font										= font_name .. " " ..						  font_size
	theme.font_bold									= font_name .. " " .. "Bold"		.. " " .. font_size
	theme.font_italic								= font_name .. " " .. "Italic"		.. " " .. font_size
	theme.font_bold_italic							= font_name .. " " .. "Bold Italic" .. " " .. font_size
	theme.font_big									= font_name .. " " .. "Bold"		.. " 16"

	theme.bar_fg									= colors.bw_5
	theme.bar_bg									= colors.bw_0
	theme.bar_highlight								= colors.bw_8
	theme.bar_good									= colors.green_2
	theme.bar_attention								= colors.red_2
	theme.bar_warning								= colors.orange_2
	theme.bar_critical								= colors.yellow_2

	theme.accent									= colors.red_2
	theme.border_normal								= colors.bw_2
	theme.border_focus								= colors.bw_5
	theme.border_marked								= colors.bw_5

	theme.fg_normal									= colors.bw_9
	theme.fg_focus									= colors.bw_9
	theme.fg_urgent									= theme.accent
	theme.bg_normal									= colors.bw_0
	theme.bg_focus									= theme.border_normal
	theme.bg_urgent									= theme.border_normal

	theme.taglist_font								= theme.font_bold
	theme.taglist_fg_normal							= colors.bw_5
	theme.taglist_fg_occupied						= colors.bw_5
	theme.taglist_fg_empty							= colors.bw_1
	theme.taglist_fg_volatile						= colors.aqua_2
	theme.taglist_fg_focus							= colors.bw_9
	theme.taglist_fg_urgent							= theme.accent
	theme.taglist_bg_normal							= colors.bw_0
	theme.taglist_bg_occupied						= colors.bw_0
	theme.taglist_bg_empty							= colors.bw_0
	theme.taglist_bg_volatile						= colors.bw_0
	theme.taglist_bg_focus							= theme.border_normal
	theme.taglist_bg_urgent							= colors.bw_1

	theme.tasklist_font_normal						= theme.font
	theme.tasklist_font_focus						= theme.font_bold
	theme.tasklist_font_urgent						= theme.font_bold
	theme.tasklist_fg_normal						= colors.bw_5
	theme.tasklist_fg_focus							= colors.bw_8
	theme.tasklist_fg_minimize						= colors.bw_2
	theme.tasklist_fg_urgent						= theme.accent
	theme.tasklist_bg_normal						= colors.bw_0
	theme.tasklist_bg_focus							= colors.bw_0
	theme.tasklist_bg_urgent						= colors.bw_0

	theme.titlebar_fg_normal						= colors.bw_5
	theme.titlebar_fg_focus							= colors.bw_8
	theme.titlebar_fg_marked						= colors.bw_8
	theme.titlebar_bg_normal						= theme.border_normal
	theme.titlebar_bg_focus							= theme.border_focus
	theme.titlebar_bg_marked						= theme.border_marked

	theme.hotkeys_border_width						= theme.border_width
	theme.hotkeys_border_color						= theme.border_focus
	theme.hotkeys_group_margin						= 50

	theme.prompt_bg									= colors.bw_0
	theme.prompt_fg									= theme.fg_normal
	theme.bg_systray								= theme.tasklist_bg_normal

	theme.border_width								= 4
	theme.border_radius								= 8
	--theme.border_radius							  = 0
	theme.fullscreen_hide_border					= true
	theme.maximized_hide_border						= true
	theme.menu_height								= 20
	theme.menu_width								= 250
	theme.tasklist_plain_task_name					= true
	theme.tasklist_disable_icon						= true
	theme.tasklist_spacing							= 3
	theme.useless_gap								= 14
	theme.systray_icon_spacing						= 4

	theme.snap_bg									= theme.border_focus
	theme.snap_shape								= function(cr, w, h)
														  gears.shape.rounded_rect(cr, w, h, theme.border_radius or 0)
													  end

													  theme.menu_submenu_icon						  = theme.dir .. "/icons/submenu.png"
	theme.awesome_icon								= theme.dir .. "/icons/awesome.png"
	-- theme.taglist_squares_sel					   = theme.dir .. "/icons/square_sel.png"
	-- theme.taglist_squares_unsel					   = theme.dir .. "/icons/square_unsel.png"
	-- theme.taglist_squares_sel_empty				   = theme.dir .. "/icons/square_sel_empty.png"
	-- theme.taglist_squares_unsel_empty			   = theme.dir .. "/icons/square_unsel_empty.png"

	theme.layout_cascadetile						= theme.dir .. "/layouts/cascadetile.png"
	theme.layout_centerwork							= theme.dir .. "/layouts/centerwork.png"
	theme.layout_cornerne							= theme.dir .. "/layouts/cornerne.png"
	theme.layout_cornernw							= theme.dir .. "/layouts/cornernw.png"
	theme.layout_cornerse							= theme.dir .. "/layouts/cornerse.png"
	theme.layout_cornersw							= theme.dir .. "/layouts/cornersw.png"
	theme.layout_dwindle							= theme.dir .. "/layouts/dwindle.png"
	theme.layout_fairh								= theme.dir .. "/layouts/fairh.png"
	theme.layout_fairv								= theme.dir .. "/layouts/fairv.png"
	theme.layout_floating							= theme.dir .. "/layouts/floating.png"
	theme.layout_fullscreen							= theme.dir .. "/layouts/fullscreen.png"
	theme.layout_magnifier							= theme.dir .. "/layouts/magnifier.png"
	theme.layout_max								= theme.dir .. "/layouts/max.png"
	theme.layout_spiral								= theme.dir .. "/layouts/spiral.png"
	theme.layout_tile								= theme.dir .. "/layouts/tile.png"
	theme.layout_tilebottom							= theme.dir .. "/layouts/tilebottom.png"
	theme.layout_tileleft							= theme.dir .. "/layouts/tileleft.png"
	theme.layout_tiletop							= theme.dir .. "/layouts/tiletop.png"

	theme.widget_ac									= theme.dir .. "/icons/ac.png"
	theme.widget_battery							= theme.dir .. "/icons/battery.png"
	theme.widget_battery_low						= theme.dir .. "/icons/battery_low.png"
	theme.widget_battery_empty						= theme.dir .. "/icons/battery_empty.png"
	theme.widget_mem								= theme.dir .. "/icons/mem.png"
	theme.widget_cpu								= theme.dir .. "/icons/cpu.png"
	theme.widget_temp								= theme.dir .. "/icons/temp.png"
	theme.widget_pacman								= theme.dir .. "/icons/pacman.png"
	theme.widget_users								= theme.dir .. "/icons/user.png"
	theme.widget_net								= theme.dir .. "/icons/net.png"
	theme.widget_hdd								= theme.dir .. "/icons/hdd.png"
	theme.widget_music								= theme.dir .. "/icons/note.png"
	theme.widget_music_on							= theme.dir .. "/icons/note_on.png"
	theme.widget_music_pause						= theme.dir .. "/icons/pause.png"
	theme.widget_music_stop							= theme.dir .. "/icons/stop.png"
	theme.widget_light								= theme.dir .. "/icons/light.png"
	theme.widget_vol								= theme.dir .. "/icons/vol.png"
	theme.widget_vol_low							= theme.dir .. "/icons/vol_low.png"
	theme.widget_vol_no								= theme.dir .. "/icons/vol_no.png"
	theme.widget_vol_mute							= theme.dir .. "/icons/vol_mute.png"
	theme.widget_mail								= theme.dir .. "/icons/mail.png"
	theme.widget_mail_on							= theme.dir .. "/icons/mail_on.png"
	theme.widget_task								= theme.dir .. "/icons/task.png"
	theme.widget_scissors							= theme.dir .. "/icons/scissors.png"

	theme.titlebar_close_button_focus				= theme.dir .. "/icons/titlebar/close_focus.png"
	theme.titlebar_close_button_normal				= theme.dir .. "/icons/titlebar/close_normal.png"
	theme.titlebar_ontop_button_focus_active		= theme.dir .. "/icons/titlebar/ontop_focus_active.png"
	theme.titlebar_ontop_button_normal_active		= theme.dir .. "/icons/titlebar/ontop_normal_active.png"
	theme.titlebar_ontop_button_focus_inactive		= theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
	theme.titlebar_ontop_button_normal_inactive		= theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
	theme.titlebar_sticky_button_focus_active		= theme.dir .. "/icons/titlebar/sticky_focus_active.png"
	theme.titlebar_sticky_button_normal_active		= theme.dir .. "/icons/titlebar/sticky_normal_active.png"
	theme.titlebar_sticky_button_focus_inactive		= theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
	theme.titlebar_sticky_button_normal_inactive	= theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
	theme.titlebar_floating_button_focus_active		= theme.dir .. "/icons/titlebar/floating_focus_active.png"
	theme.titlebar_floating_button_normal_active	= theme.dir .. "/icons/titlebar/floating_normal_active.png"
	theme.titlebar_floating_button_focus_inactive	= theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
	theme.titlebar_floating_button_normal_inactive	= theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
	theme.titlebar_minimize_button_focus_active		= theme.dir .. "/icons/titlebar/minimized_focus_active.png"
	theme.titlebar_minimize_button_normal_active	= theme.dir .. "/icons/titlebar/minimized_normal_active.png"
	theme.titlebar_minimize_button_focus_inactive	= theme.dir .. "/icons/titlebar/minimized_focus_inactive.png"
	theme.titlebar_minimize_button_normal_inactive	= theme.dir .. "/icons/titlebar/minimized_normal_inactive.png"
	theme.titlebar_maximized_button_focus_active	= theme.dir .. "/icons/titlebar/maximized_focus_active.png"
	theme.titlebar_maximized_button_normal_active	= theme.dir .. "/icons/titlebar/maximized_normal_active.png"
	theme.titlebar_maximized_button_focus_inactive	= theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
	theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

	theme.tooltip_fg								= theme.titlebar_fg_focus
	theme.tooltip_bg								= theme.titlebar_bg_normal
	theme.tooltip_border_color						= theme.border_normal
	theme.tooltip_border_width						= theme.border_width

	theme.notification_fg							= theme.fg_normal
	theme.notification_bg							= theme.bg_normal
	theme.notification_border_color					= theme.border_normal
	theme.notification_border_width					= theme.border_width
	theme.notification_icon_size					= 80
	theme.notification_opacity						= 1
	theme.notification_max_width					= 600
	theme.notification_max_height					= 400
	theme.notification_margin						= 20
	theme.notification_shape						= function(cr, width, height)
														  gears.shape.rounded_rect(cr, width, height, theme.border_radius or 0)
													  end

	naughty.config.padding							= 15
	naughty.config.spacing							= 10
	naughty.config.defaults.timeout					= 5
	naughty.config.defaults.margin					= theme.notification_margin
	naughty.config.defaults.border_width			= theme.notification_border_width

	naughty.config.presets.normal					= {
														  font		   = theme.font,
														  fg		   = theme.notification_fg,
														  bg		   = theme.notification_bg,
														  border_width = theme.notification_border_width,
														  margin	   = theme.notification_margin,
													  }

	naughty.config.presets.low						= naughty.config.presets.normal
	naughty.config.presets.ok						= naughty.config.presets.normal
	naughty.config.presets.info						= naughty.config.presets.normal
	naughty.config.presets.warn						= naughty.config.presets.normal

	naughty.config.presets.critical					= {
														  font		   = theme.font,
														  fg		   = colors.red_2,
														  bg		   = theme.notification_bg,
														  border_width = theme.notification_border_width,
														  margin	   = theme.notification_margin,
														  timeout	   = 0,
													  }
	return theme

end

return common

