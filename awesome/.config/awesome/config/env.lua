local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

env = { }

env.mod = "Mod4"

env.browser = "exo-open --launch WebBrowser" or "firefox"
env.filemanager = "exo-open --launch FileManager" or "thunar"
env.gui_editor = "mousepad"
env.terminal = "alacritty"

env.wallpaper = function(s)
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		if awful.util.file_readable(beautiful.wallpaper) then
			gears.wallpaper.maximized(beautiful.wallpaper, s, true)
		else
			gears.wallpaper.set(beautiful.bg_normal)
		end
	end
end

return env

