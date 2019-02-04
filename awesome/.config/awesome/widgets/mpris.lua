local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local helpers = require("helpers")

-- Set colors
local title_color =  beautiful.mpd_song_title_color or beautiful.wibar_fg
local artist_color = beautiful.mpd_song_artist_color or beautiful.wibar_fg
local paused_color = beautiful.mpd_song_paused_color or beautiful.normal_fg

local mpris = wibox.widget{
	{
		text = "---",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox
	},
	{
		text = "---",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox
	},
	layout = wibox.layout.fixed.vertical,
}

-- Extra stuff requiered for multiline shell output
local mpris_script = { awful.util.shell, "-c", "playerctl status && playerctl metadata" }

local function update_widget(widget, stdout)
	local mpris_now = {
		state		  = "N/A",
		artist		  = "N/A",
		title		  = "N/A",
		art_url		  = "N/A",
		album		  = "N/A",
		album_artist  = "N/A"
	}

	mpris_now.state = string.match(stdout, "Playing") or
					  string.match(stdout, "Paused")  or "N/A"

	local title_fg
	local artist_fg

	if mpris_now.state == "Paused" then
		artist_fg = paused_color
		title_fg = paused_color
	else
		artist_fg = artist_color
		title_fg = title_color
	end

	for k, v in string.gmatch(stdout, "'[^:]+:([^']+)':[%s]<%[?'([^']+)'%]?>")
	do
		if	   k == "artUrl"	   then mpris_now.art_url	   = v
		elseif k == "artist"	   then mpris_now.artist	   = gears.string.xml_escape(v)
		elseif k == "title"		   then mpris_now.title		   = gears.string.xml_escape(v)
		elseif k == "album"		   then mpris_now.album		   = gears.string.xml_escape(v)
		elseif k == "albumArtist"  then mpris_now.album_artist = gears.string.xml_escape(v)
		end
	end

	local mpris_children = widget:get_all_children()
	mpris_children[1]:set_markup("<span foreground='" .. title_fg .."'>" .. mpris_now.title .. "</span>")
	mpris_children[2]:set_markup("<span foreground='" .. artist_fg .."'>" .. mpris_now.artist .. "</span>")
end

awful.widget.watch(mpris_script, 1, function(widget, stdout) update_widget(widget, stdout) end, mpris)

return mpris
