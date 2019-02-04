local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- Configuration
local key = "9f860fe589d11abb153cc65934638e0c"
local city_id = "2154720"
local units = "metric"
local symbol = "°C"
local update_interval = 120 -- in seconds

local weather_text = wibox.widget {
	text = "Loading...",
	valign = "center",
	widget = wibox.widget.textbox,
}

local weather_icon = wibox.widget.imagebox(beautiful.whatever_icon)
weather_icon.resize = true
weather_icon.forced_width = 40
weather_icon.forced_height = 40

local weather = wibox.widget {
	weather_icon,
	weather_text,
	layout = wibox.layout.fixed.horizontal
}

local function update_widget(icon_code, weather_details)
	if string.find(icon_code, "01d") then
		weather_icon.image = beautiful.sun_icon
	elseif string.find(icon_code, "01n") then
		weather_icon.image = beautiful.star_icon
	elseif string.find(icon_code, "02d") then
		weather_icon.image = beautiful.dcloud_icon
	elseif string.find(icon_code, "02n") then
		weather_icon.image = beautiful.ncloud
	elseif string.find(icon_code, "03") or string.find(icon_code, "04") then
		weather_icon.image = beautiful.cloud_icon
	elseif string.find(icon_code, "09") or string.find(icon_code, "10") then
		weather_icon.image = beautiful.rain_icon
	elseif string.find(icon_code, "11") then
		weather_icon.image = beautiful.storm_icon
	elseif string.find(icon_code, "13") then
		weather_icon.image = beautiful.snow_icon
	elseif string.find(icon_code, "40") or string.find(icon_code, "50") then
		weather_icon.image = beautiful.mist_icon
	else
		weather_icon.image = beautiful.weather_icon
	end

	weather_text.markup = weather_details
end

local weather_details_script = [[
	bash -c '
	KEY="]]..key..[["
	CITY="]]..city_id..[["
	UNITS="]]..units..[["
	SYMBOL="]]..symbol..[["

	weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?APPID=$KEY&id=$CITY&units=$UNITS")

	if [ ! -z "$weather" ]; then
		weather_temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
		weather_icon=$(echo "$weather" | jq -r ".weather[].icon" | head -1)
		weather_description=$(echo "$weather" | jq -r ".weather[].description" | head -1)
		echo "$weather_icon" "$weather_description" "$weather_temp$SYMBOL"
	else
		echo "... Info unavailable"
	fi
']]

awful.widget.watch(weather_details_script, update_interval, function(widget, stdout)
	local icon_code = string.sub(stdout, 1, 3)
	local weather_details = string.sub(stdout, 5)
	weather_details = string.gsub(weather_details, '^%s*(.-)%s*$', '%1')
	update_widget(icon_code, weather_details)
end)

return weather

