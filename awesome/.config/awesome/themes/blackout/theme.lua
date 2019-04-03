local common			= require("themes.out_common")

local colors = { }

colors.black_1			= "#282828"
colors.black_2			= "#928374"
colors.red_1			= "#cc241d"
colors.red_2			= "#fb4934"
colors.green_1			= "#98971a"
colors.green_2			= "#b8bb26"
colors.yellow_1			= "#d79921"
colors.yellow_2			= "#fabd2f"
colors.blue_1			= "#458588"
colors.blue_2			= "#83a598"
colors.purple_1			= "#b16286"
colors.purple_2			= "#d3869b"
colors.aqua_1			= "#689d6a"
colors.aqua_2			= "#8ec07c"
colors.white_1			= "#a89984"
colors.white_2			= "#ebdbb2"
colors.orange_1			= "#d65d0e"
colors.orange_2			= "#fe8019"

colors.bw_0_h			= "#1d2021"
colors.bw_0				= "#282828"
colors.bw_0_s			= "#32302f"
colors.bw_1				= "#3c3836"
colors.bw_2				= "#504945"
colors.bw_3				= "#665c54"
colors.bw_4				= "#7c6f64"
colors.bw_5				= "#928374"
colors.bw_6				= "#a89984"
colors.bw_7				= "#bdae93"
colors.bw_8				= "#d5c4a1"
colors.bw_9				= "#ebdbb2"
colors.bw_10			= "#fbf1c7"


local theme = { }
theme.name = "blackout"
theme.alternative = "whiteout"
theme.dir = string.format("%s/.config/awesome/themes/%s", os.getenv("HOME"), theme.name)

theme = common.init(theme, colors)

return theme

